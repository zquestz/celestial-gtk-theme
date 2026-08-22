#! /usr/bin/env bash
#
# Generate the Celestial ttk theme variants from the compiled GTK stylesheets.
#
# Every colour here is read out of src/gtk/, so the ttk themes cannot drift
# from the rest of the theme: change a palette in sass/_colors.scss, run
# parse_sass.sh, then run this.
#
# Tk has no alpha channel, so Celestial's translucent tokens (borders, the
# insensitive foreground, and the tab hover accent) are composited over each
# variant's own background here and emitted as solid values.
#
# Celestial's Standard and Light modes differ only in window-manager chrome,
# which Tk does not draw, so they share one theme under the -light name,
# matching how the other two-mode extras are named.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}" || exit 1

GTK4="../../gtk/gtk-4.0"
GTK3="../../gtk/gtk-3.0"

COLORS=(sea aliz azul pueril)
MODES=('-light' '-dark')

# ---------------------------------------------------------------- colour math

# Normalise a CSS colour to "r g b". Handles #rrggbb, rgba(...) and the few
# bare keywords the stylesheets use.
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

  if [[ "${c}" == rgba* || "${c}" == rgb* ]]; then
    local inner="${c#*(}"
    inner="${inner%)*}"
    IFS=',' read -r r g b _ <<< "${inner}"
    printf "%d %d %d\n" "$((r))" "$((g))" "$((b))"
    return
  fi

  echo "0 0 0"
}

# Alpha of an rgba() as an integer percentage; 100 for anything opaque.
alpha_pct() {
  local c="$1"
  if [[ "${c}" != rgba* ]]; then
    echo 100
    return
  fi
  local inner="${c#*(}"
  inner="${inner%)*}"
  local a
  a="$(echo "${inner}" | awk -F',' '{gsub(/ /,"",$4); print $4}')"
  [[ -z "${a}" ]] && { echo 100; return; }
  # 0.45 -> 45, .6 -> 60, 1 -> 100
  awk -v a="${a}" 'BEGIN { printf "%d", (a * 100) + 0.5 }'
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

# ------------------------------------------------------------------ extraction

# Value of an @define-color, verbatim.
define_color() {
  local file="$1" name="$2"
  grep -oE "@define-color ${name} [^;]*;" "${file}" \
    | head -1 | sed -E "s/@define-color ${name} //; s/;$//"
}

# background-color of the first rule whose selector line matches exactly.
rule_bg() {
  local file="$1" selector="$2"
  awk -v sel="${selector}" '
    $0 == sel " {" { inrule = 1; next }
    inrule && /background-color:/ {
      gsub(/^[ \t]*background-color:[ \t]*/, "")
      gsub(/;$/, "")
      print
      exit
    }
    inrule && /^}/ { inrule = 0 }
  ' "${file}"
}

# The column divider GTK draws down the right of each header cell, as the
# middle stop of a border-image gradient. Light variants tint it with black,
# dark ones with white, so it must be read rather than assumed.
heading_line() {
  local file="$1"
  awk '
    /^columnview.view > header > button,/ { inrule = 1 }
    inrule && /border-image:/ {
      if (match($0, /rgba\([^)]*\)/)) {
        print substr($0, RSTART, RLENGTH)
        exit
      }
    }
    inrule && /^}/ { inrule = 0 }
  ' "${file}"
}

# Heading foreground, which GTK sets on the treeview header button.
heading_fg() {
  local file="$1"
  awk '
    /^treeview.view header button \{/ { inrule = 1; next }
    inrule && /^  color:/ {
      gsub(/^[ \t]*color:[ \t]*/, "")
      gsub(/;$/, "")
      print
      exit
    }
    inrule && /^}/ { inrule = 0 }
  ' "${file}"
}

title_case() {
  case "$1" in
    sea) echo "Sea" ;;
    aliz) echo "Aliz" ;;
    azul) echo "Azul" ;;
    pueril) echo "Pueril" ;;
  esac
}

# Extraction failures must fail the build loudly: an empty value would
# otherwise flow through composite as black and ship silently.
require() {
  if [[ -z "$2" ]]; then
    echo "ERROR: could not extract $1" >&2
    exit 1
  fi
}

# ---------------------------------------------------------------------- emit

emit_variant() {
  local color="$1" mode="$2"
  local src4="${GTK4}/gtk-${color}${mode}.css"
  local src3="${GTK3}/gtk-${color}${mode}.css"
  local theme="celestial-${color}${mode}"
  local out="${theme}.tcl"

  local bg fg text inputbg selectbg selectfg disabledbg
  bg="$(define_color "${src4}" theme_bg_color)"
  fg="$(define_color "${src4}" theme_fg_color)"
  text="$(define_color "${src4}" theme_text_color)"
  inputbg="$(define_color "${src4}" theme_base_color)"
  selectbg="$(define_color "${src4}" theme_selected_bg_color)"
  selectfg="$(define_color "${src4}" theme_selected_fg_color)"
  disabledbg="$(define_color "${src4}" insensitive_bg_color)"

  local success warning danger
  success="$(define_color "${src4}" success_color)"
  warning="$(define_color "${src4}" warning_color)"
  danger="$(define_color "${src4}" error_color)"

  local button active
  button="$(rule_bg "${src4}" "button")"
  active="$(rule_bg "${src4}" "button:hover")"
  button="$(composite "${button}" 100 "${bg}")"
  active="$(composite "${active}" 100 "${bg}")"

  # Translucent tokens, flattened over this variant's own background.
  local borders_raw ifg_raw border disabledfg tabhover
  borders_raw="$(define_color "${src4}" borders)"
  ifg_raw="$(define_color "${src4}" insensitive_fg_color)"
  border="$(composite "${borders_raw}" "$(alpha_pct "${borders_raw}")" "${bg}")"
  disabledfg="$(composite "${ifg_raw}" "$(alpha_pct "${ifg_raw}")" "${bg}")"
  # GTK writes the tab hover as alpha(accent, 0.6).
  tabhover="$(composite "${selectbg}" 60 "${bg}")"

  local headingfg headingline line_raw
  headingfg="$(heading_fg "${src3}")"
  line_raw="$(heading_line "${src4}")"
  headingline="$(composite "${line_raw}" "$(alpha_pct "${line_raw}")" "${inputbg}")"

  # Widget-specific colours GTK sets outside the named palette.
  local accenthover scrollslider scrollhover scaleslider progresstrough v
  v="$(rule_bg "${src4}" "button.suggested-action:hover")"
  require accenthover "${v}"
  accenthover="$(composite "${v}" "$(alpha_pct "${v}")" "${bg}")"
  v="$(rule_bg "${src3}" "scrollbar slider")"
  require scrollslider "${v}"
  scrollslider="$(composite "${v}" "$(alpha_pct "${v}")" "${bg}")"
  v="$(rule_bg "${src3}" "scrollbar slider:hover")"
  require scrollhover "${v}"
  scrollhover="$(composite "${v}" "$(alpha_pct "${v}")" "${bg}")"
  v="$(rule_bg "${src3}" "scale slider")"
  require scaleslider "${v}"
  scaleslider="$(composite "${v}" "$(alpha_pct "${v}")" "${bg}")"
  v="$(rule_bg "${src3}" "progressbar trough")"
  require progresstrough "${v}"
  progresstrough="$(composite "${v}" "$(alpha_pct "${v}")" "${bg}")"

  require bg "${bg}"; require fg "${fg}"; require text "${text}"
  require button "${button}"; require active "${active}"
  require headingfg "${headingfg}"; require headingline "${line_raw}"
  require borders "${borders_raw}"; require insensitive_fg "${ifg_raw}"

  local modetitle="Light"
  local suffix='""'
  if [[ "${mode}" == "-dark" ]]; then
    modetitle="Dark"
    suffix="-dark"
  fi

  local titled
  titled="$(title_case "${color}")"

  local standardnote=""
  if [[ "${mode}" != "-dark" ]]; then
    standardnote="
# Serves both the Standard and Light Celestial modes: they differ only in
# window-manager chrome, which Tk does not draw."
  fi

  cat > "${out}" <<EOF
#
# Celestial ${titled} ${modetitle} - ttk theme
#
# Generated by render.sh from the compiled GTK stylesheets. Do not edit;
# change sass/_colors.scss, run parse_sass.sh, then re-run render.sh.
#
# Colour definitions only; all widget styling lives in celestial.tcl.${standardnote}
#
# Tk has no alpha, so Celestial's translucent tokens arrive here already
# composited over this variant's background:
#   borders          -> ${border}
#   insensitive fg   -> ${disabledfg}
#   alpha(accent,.6) -> ${tabhover}   (GTK's notebook tab hover)
#

package require Tk 8.6

# Loadable either as an installed package or straight from the source tree.
if {[catch {package require celestial::ttk}]} {
  source [file join [file dirname [info script]] celestial.tcl]
}

namespace eval ::ttk::theme::${theme} {
  package provide ttk::theme::${theme} 1.0

  ::celestial::ttk::create ${theme} [file dirname [info script]] \\
    -variant ${color}${mode} -gtkcolor ${color} -suffix ${suffix} -colors {
      -bg          ${bg}
      -fg          ${fg}
      -text        ${text}
      -headingfg   ${headingfg}
      -headingline ${headingline}
      -disabledfg  ${disabledfg}
      -disabledbg  ${disabledbg}
      -button      ${button}
      -active      ${active}
      -inputbg     ${inputbg}
      -trough      ${border}
      -border      ${border}
      -selectbg    ${selectbg}
      -selectfg    ${selectfg}
      -primary     ${selectbg}
      -accenthover ${accenthover}
      -tabhover    ${tabhover}
      -scrollslider ${scrollslider}
      -scrollhover ${scrollhover}
      -scaleslider ${scaleslider}
      -progresstrough ${progresstrough}
      -success     ${success}
      -warning     ${warning}
      -danger      ${danger}
    }
}
EOF

  echo "==> Generated ${out}"
}

emit_pkgindex() {
  {
    cat <<'EOF'
# Celestial ttk themes.
#
# Generated by render.sh. Do not edit.
#
# Registering each variant as a package is what makes the global X resource
# path work: ttk::DefaultTheme reads *TkTheme from the option database and
# does 'package require ttk::theme::<name>', so every Tk app picks the theme
# up with no per-application opt-in.
#
# Requires this directory on Tcl's auto_path: a system-wide install under
# /usr/lib, or TCLLIBPATH for a per-user one.

package ifneeded celestial::ttk 1.0 \
  [list source [file join $dir celestial.tcl]]
EOF
    local color mode theme
    for color in "${COLORS[@]}"; do
      for mode in "${MODES[@]}"; do
        theme="celestial-${color}${mode}"
        printf '\npackage ifneeded ttk::theme::%s 1.0 \\\n' "${theme}"
        # $dir is a Tcl variable resolved by pkgIndex.tcl at load time, so it
        # must reach the output literally.
        # shellcheck disable=SC2016
        printf '  [list source [file join $dir %s.tcl]]\n' "${theme}"
      done
    done
  } > pkgIndex.tcl

  echo "==> Generated pkgIndex.tcl"
}

rm -f celestial-*.tcl

for color in "${COLORS[@]}"; do
  for mode in "${MODES[@]}"; do
    emit_variant "${color}" "${mode}"
  done
done

emit_pkgindex

echo "Done."
