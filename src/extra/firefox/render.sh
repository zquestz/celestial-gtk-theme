#! /usr/bin/env bash
#
# Generate the Celestial Firefox themes from the compiled GTK stylesheets.
#
# Each variant becomes an unpacked WebExtension static theme at
# celestial-<variant>/manifest.json, loadable in dev mode via
# about:debugging. Every colour is read out of src/gtk/, so the themes
# cannot drift from the rest of the theme: change a palette in
# sass/_colors.scss, run parse_sass.sh, then run this.
#
# Firefox draws the titlebar (the manifest's "frame"), which is the only
# place Celestial's Standard and Light modes differ, so all twelve variants
# are generated: Standard keeps its signature dark frame over light content.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}" || exit 1

GTK4="../../gtk/gtk-4.0"

COLORS=(sea aliz azul pueril)
MODES=('' '-light' '-dark')

# ---------------------------------------------------------------- colour math

# Normalise a CSS colour to "r g b".
to_rgb() {
  local c="$1"
  c="${c#"${c%%[![:space:]]*}"}"
  c="${c%"${c##*[![:space:]]}"}"

  case "${c}" in
    white) echo "255 255 255"; return ;;
    black) echo "0 0 0"; return ;;
  esac

  if [[ "${c}" == \#* ]]; then
    local h="${c#\#}"
    printf "%d %d %d\n" "0x${h:0:2}" "0x${h:2:2}" "0x${h:4:2}"
    return
  fi

  echo "0 0 0"
}

# Composite $1 over $3 at $2 percent, returning #rrggbb.
composite() {
  local fg="$1" pct="$2" bg="$3"
  local fr fg_ fb br bg_ bb
  read -r fr fg_ fb <<< "$(to_rgb "${fg}")"
  read -r br bg_ bb <<< "$(to_rgb "${bg}")"
  printf "#%02x%02x%02x\n" \
    $(( (pct * fr + (100 - pct) * br + 50) / 100 )) \
    $(( (pct * fg_ + (100 - pct) * bg_ + 50) / 100 )) \
    $(( (pct * fb + (100 - pct) * bb + 50) / 100 ))
}

# "#rrggbb" and an alpha like 0.08 as "rgba(r, g, b, a)".
to_rgba() {
  local hex="$1" a="$2"
  local r g b
  read -r r g b <<< "$(to_rgb "${hex}")"
  printf "rgba(%d, %d, %d, %s)\n" "${r}" "${g}" "${b}" "${a}"
}

# ------------------------------------------------------------------ extraction

# Value of an @define-color, verbatim.
define_color() {
  local file="$1" name="$2"
  grep -oE "@define-color ${name} [^;]*;" "${file}" \
    | head -1 | sed -E "s/@define-color ${name} //; s/;$//"
}

# GTK writes the titlebar text as alpha(#rrggbb, a); flatten it over the
# frame so the manifest carries a solid colour.
frame_text() {
  local raw="$1" frame="$2"
  if [[ "${raw}" == alpha\(* ]]; then
    local hex pct
    hex="$(grep -oE '#[0-9a-f]{6}' <<< "${raw}")"
    pct="$(awk -F'[,)]' '{gsub(/ /,"",$2); printf "%d", ($2 * 100) + 0.5}' <<< "${raw}")"
    composite "${hex}" "${pct}" "${frame}"
  else
    echo "${raw}"
  fi
}

# Extraction failures must fail the build loudly: an empty value would
# otherwise flow through composite as black and ship silently.
require() {
  if [[ -z "$2" ]]; then
    echo "ERROR: could not extract $1" >&2
    exit 1
  fi
}

title_case() {
  case "$1" in
    sea) echo "Sea" ;;
    aliz) echo "Aliz" ;;
    azul) echo "Azul" ;;
    pueril) echo "Pueril" ;;
  esac
}

# The accent names the rest of the theme's documentation uses.
accent_word() {
  case "$1" in
    sea) echo "Teal" ;;
    aliz) echo "Coral red" ;;
    azul) echo "Blue" ;;
    pueril) echo "Green" ;;
  esac
}

# ---------------------------------------------------------------------- emit

emit_variant() {
  local color="$1" mode="$2"
  local src="${GTK4}/gtk-${color}${mode}.css"
  local dir="celestial-${color}${mode}"

  local bg base fg text accent selectfg frame title_raw frametext
  bg="$(define_color "${src}" theme_bg_color)"
  base="$(define_color "${src}" theme_base_color)"
  fg="$(define_color "${src}" theme_fg_color)"
  text="$(define_color "${src}" theme_text_color)"
  accent="$(define_color "${src}" theme_selected_bg_color)"
  selectfg="$(define_color "${src}" theme_selected_fg_color)"
  frame="$(define_color "${src}" wm_bg)"
  title_raw="$(define_color "${src}" wm_title)"

  require theme_bg_color "${bg}"
  require theme_base_color "${base}"
  require theme_fg_color "${fg}"
  require theme_text_color "${text}"
  require theme_selected_bg_color "${accent}"
  require theme_selected_fg_color "${selectfg}"
  require wm_bg "${frame}"
  require wm_title "${title_raw}"

  frametext="$(frame_text "${title_raw}" "${frame}")"

  local field
  field="$(to_rgba "${text}" 0.08)"

  local titled name accent_name interface
  titled="$(title_case "${color}")"
  accent_name="$(accent_word "${color}")"

  # The name already carries the project and the mode, so the description
  # only supplies what it cannot: what the colour word actually looks like.
  case "${mode}" in
    -light)
      name="Celestial ${titled} Light"
      interface="on a light interface"
      ;;
    -dark)
      name="Celestial ${titled} Dark"
      interface="on a dark interface"
      ;;
    *)
      # Standard names neither mode, and pairs light content with a dark
      # titlebar, so it is the one variant whose look needs spelling out.
      name="Celestial ${titled}"
      interface="on a light interface with a dark titlebar"
      ;;
  esac

  local description
  description="${accent_name} accent ${interface}."

  # color_scheme follows the toolbar, which is the surface most of Firefox's
  # chrome decisions key off. Standard therefore reads as light despite its
  # dark titlebar. Firefox otherwise has to infer it from the colours, and
  # Standard is exactly the case where that inference is a coin toss.
  local scheme="light"
  [[ "${mode}" == "-dark" ]] && scheme="dark"

  mkdir -p "${dir}"

  cat > "${dir}/manifest.json" <<EOF
{
  "manifest_version": 3,
  "version": "1.0",
  "name": "${name}",
  "description": "${description}",
  "author": "Josh Ellithorpe",
  "homepage_url": "https://github.com/zquestz/celestial-gtk-theme",
  "browser_specific_settings": {
    "gecko": {
      "id": "${dir}@zquestz.github.io"
    }
  },
  "theme": {
    "colors": {
      "frame": "${frame}",
      "tab_background_text": "${frametext}",
      "tab_selected": "${accent}",
      "tab_text": "${selectfg}",
      "tab_line": "${accent}",
      "tab_loading": "${accent}",
      "toolbar": "${base}",
      "toolbar_text": "${fg}",
      "toolbar_field": "${field}",
      "toolbar_field_text": "${text}",
      "toolbar_field_focus": "${base}",
      "toolbar_field_text_focus": "${text}",
      "toolbar_field_highlight": "${accent}",
      "toolbar_field_highlight_text": "${selectfg}",
      "popup": "${base}",
      "popup_text": "${text}",
      "popup_highlight": "${accent}",
      "popup_highlight_text": "${selectfg}",
      "button_background_active": "${accent}",
      "ntp_background": "${bg}",
      "ntp_text": "${fg}"
    },
    "properties": {
      "color_scheme": "${scheme}"
    }
  }
}
EOF

  echo "==> Generated ${dir}/manifest.json"
}

rm -rf celestial-*/

for color in "${COLORS[@]}"; do
  for mode in "${MODES[@]}"; do
    emit_variant "${color}" "${mode}"
  done
done

echo "Done."
