#! /usr/bin/env bash
#
# Generate the Celestial Spotifast themes from the compiled GTK stylesheets.
#
# Spotifast reads JSON palettes from ~/.config/spotifast/themes/ and lists
# each one in its theme picker under its file name, so the files are named
# the way its bundled palettes are ("Rose Pine Dawn.json"). Every colour is
# read out of src/gtk/, so the themes cannot drift from the rest of the
# theme: change a palette in src/gtk/sass/_colors.scss, run parse_sass.sh,
# then run this.
#
# Celestial's Standard mode pairs light content with dark chrome such as
# titlebars, menubars and sidebars. A Spotifast palette has one set of text
# colours for every surface, so a dark sidebar would hide its text. Each
# colour therefore gets a Light and a Dark palette, and Standard maps to
# Light.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}" || exit 1

GTK4="../../gtk/gtk-4.0"

COLORS=(sea aliz azul pueril)
MODES=(-light -dark)

# ---------------------------------------------------------------- colour math

# Parse a CSS colour into R, G and B, with its alpha as a percentage in A.
# GTK writes #rrggbb, white, black and rgba(r, g, b, a); anything else stops
# the build rather than shipping as black.
parse_colour() {
  local c="$1"
  local hex_re='^#([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2})$'
  local rgba_re='^rgba\(([0-9]+), *([0-9]+), *([0-9]+), *([0-9.]+)\)$'

  if [[ "${c}" =~ ${hex_re} ]]; then
    R=$((16#${BASH_REMATCH[1]}))
    G=$((16#${BASH_REMATCH[2]}))
    B=$((16#${BASH_REMATCH[3]}))
    A=100
  elif [[ "${c}" == white ]]; then
    R=255 G=255 B=255 A=100
  elif [[ "${c}" == black ]]; then
    R=0 G=0 B=0 A=100
  elif [[ "${c}" =~ ${rgba_re} ]]; then
    R="${BASH_REMATCH[1]}"
    G="${BASH_REMATCH[2]}"
    B="${BASH_REMATCH[3]}"
    A="$(awk -v a="${BASH_REMATCH[4]}" 'BEGIN { printf "%d", a * 100 + 0.5 }')"
  else
    echo "ERROR: unsupported colour '${c}'" >&2
    exit 1
  fi
}

# Composite colour $1 over $3 at $2 percent, returning #rrggbb.
composite() {
  local pct="$2" fr fg_ fb
  parse_colour "$1"
  fr="${R}" fg_="${G}" fb="${B}"
  parse_colour "$3"
  printf "#%02x%02x%02x\n" \
    $(( (pct * fr + (100 - pct) * R + 50) / 100 )) \
    $(( (pct * fg_ + (100 - pct) * G + 50) / 100 )) \
    $(( (pct * fb + (100 - pct) * B + 50) / 100 ))
}

# A GTK colour as Spotifast's #rrggbb. Translucent colours are flattened over
# $2, the opaque surface they sit on.
solid() {
  parse_colour "$1"
  if (( A < 100 )); then
    composite "$(printf "#%02x%02x%02x" "${R}" "${G}" "${B}")" "${A}" "$2"
  else
    printf "#%02x%02x%02x\n" "${R}" "${G}" "${B}"
  fi
}

# ------------------------------------------------------------------ extraction

# Value of an @define-color, verbatim, or nothing when it is missing.
define_color() {
  local file="$1" name="$2"
  { grep -oE "@define-color ${name} [^;]*;" "${file}" || true; } \
    | head -1 | sed -E "s/@define-color ${name} //; s/;$//"
}

# The background GTK gives a hovered selected row: the theme's lighter accent
# ($alt_selected_bg_color), which no @define-color exports.
selected_hover() {
  { grep -A1 -E "^row:selected:hover, row:selected\.has-open-popup \{" "$1" || true; } \
    | grep -oE "#[0-9a-f]{6}" | head -1 || true
}

# Name the colour when extraction fails. An empty value would otherwise reach
# parse_colour, which stops the build without saying which one went missing.
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

mode_name() {
  case "$1" in
    -light) echo "Light" ;;
    -dark) echo "Dark" ;;
  esac
}

# ---------------------------------------------------------------------- emit

emit_variant() {
  local color="$1" mode="$2"
  local src="${GTK4}/gtk-${color}${mode}.css"

  local view_bg_color window_bg_color window_fg_color borders
  local insensitive_fg_color accent_bg_color accent_fg_color hover_bg
  local error_color warning_color popover_bg_color
  view_bg_color="$(define_color "${src}" view_bg_color)"
  window_bg_color="$(define_color "${src}" window_bg_color)"
  window_fg_color="$(define_color "${src}" window_fg_color)"
  borders="$(define_color "${src}" borders)"
  insensitive_fg_color="$(define_color "${src}" insensitive_fg_color)"
  accent_bg_color="$(define_color "${src}" accent_bg_color)"
  accent_fg_color="$(define_color "${src}" accent_fg_color)"
  hover_bg="$(selected_hover "${src}")"
  error_color="$(define_color "${src}" error_color)"
  warning_color="$(define_color "${src}" warning_color)"
  popover_bg_color="$(define_color "${src}" popover_bg_color)"

  require view_bg_color "${view_bg_color}"
  require window_bg_color "${window_bg_color}"
  require window_fg_color "${window_fg_color}"
  require borders "${borders}"
  require insensitive_fg_color "${insensitive_fg_color}"
  require accent_bg_color "${accent_bg_color}"
  require accent_fg_color "${accent_fg_color}"
  require "the row:selected:hover background" "${hover_bg}"
  require error_color "${error_color}"
  require warning_color "${warning_color}"
  require popover_bg_color "${popover_bg_color}"

  # Spotifast fills its main content area with "window" and its sidebar and
  # player bar with "panel": GTK's content views, and the window background
  # around them. Menus, popups and dialogs ("overlay") take GTK's popover
  # colour. Everything translucent is flattened over the content colour,
  # where most of Spotifast's widgets sit.
  local window panel overlay
  window="$(solid "${view_bg_color}" "${window_bg_color}")"
  panel="$(solid "${window_bg_color}" "${window}")"
  overlay="$(solid "${popover_bg_color}" "${window}")"

  # Spotifast draws its buttons, fields and chips without borders, while
  # GTK's button colours rely on one, and GTK's dimmed text is the same as
  # its disabled text in the light variants. The widget fills and the
  # secondary text therefore use the ratios of Spotifast's own Omarchy
  # template, mixing the GTK foreground into the content colour.
  local surface surface_hover surface_active secondary
  surface="$(composite "${window_fg_color}" 8 "${window}")"
  surface_hover="$(composite "${window_fg_color}" 12 "${window}")"
  surface_active="$(composite "${window_fg_color}" 18 "${window}")"
  secondary="$(composite "${window_fg_color}" 70 "${window}")"

  local outline text dim accent accent_hover on_accent danger warning
  outline="$(solid "${borders}" "${window}")"
  text="$(solid "${window_fg_color}" "${window}")"
  dim="$(solid "${insensitive_fg_color}" "${window}")"
  accent="$(solid "${accent_bg_color}" "${window}")"
  accent_hover="$(solid "${hover_bg}" "${window}")"
  on_accent="$(solid "${accent_fg_color}" "${window}")"
  danger="$(solid "${error_color}" "${window}")"
  warning="$(solid "${warning_color}" "${window}")"

  local base="light"
  [[ "${mode}" == "-dark" ]] && base="dark"

  local file
  file="Celestial $(title_case "${color}") $(mode_name "${mode}").json"

  # "shadow" is left to Spotifast's default, as its bundled palettes leave it.
  cat > "${file}" <<EOF
{
  "base": "${base}",
  "colors": {
    "window": "${window}",
    "panel": "${panel}",
    "surface": "${surface}",
    "surface_hover": "${surface_hover}",
    "surface_active": "${surface_active}",
    "outline": "${outline}",
    "text": "${text}",
    "secondary": "${secondary}",
    "dim": "${dim}",
    "accent": "${accent}",
    "accent_hover": "${accent_hover}",
    "on_accent": "${on_accent}",
    "danger": "${danger}",
    "warning": "${warning}",
    "overlay": "${overlay}"
  }
}
EOF

  echo "==> Generated ${file}"
}

rm -f -- "Celestial "*.json

for color in "${COLORS[@]}"; do
  for mode in "${MODES[@]}"; do
    emit_variant "${color}" "${mode}"
  done
done

echo "Done."
