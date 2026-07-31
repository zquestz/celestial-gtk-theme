#! /usr/bin/env bash
# shellcheck disable=SC2064
# Generates all KDE Plasma artifacts from the GTK sass palette:
#   - color-schemes/*.colors            (Qt/KDE color schemes)
#   - look-and-feel/<id>/               (global theme packages; folder name == KPlugin Id)
#       metadata.json, contents/defaults, contents/colors,
#       contents/previews/preview.png, contents/previews/fullscreenpreview.jpg
#   - desktoptheme/<name>/              (Plasma desktop themes: full widget set)
#       metadata.json, colors, widgets/, dialogs/
#   - aurorae/<name>/                   (window decorations; KWin id __aurorae__svg__<name>)
#       decoration.svg, button SVGs, <name>rc, metadata.desktop
# Aurorae inputs live in aurorae-base/: the decoration frames are vendored from
# arc-kde (tokenized), the buttons are Celestial's own GTK titlebutton designs.
# Desktop theme SVGs live in desktoptheme-base/ - Celestial's base, originally
# adapted from arc-kde; stylesheet-based, recolored per variant at runtime.
# Run this after changing src/gtk/sass/_colors.scss, then commit the outputs.

if [ ! "$(which sassc 2> /dev/null)" ]; then
  echo sassc needs to be installed to generate the color schemes.
  exit 1
fi

if [ ! "$(which rsvg-convert 2> /dev/null)" ]; then
  echo rsvg-convert needs to be installed to render the previews.
  exit 1
fi

if command -v magick > /dev/null 2>&1; then
  JPEG_CONVERT=(magick)
elif command -v convert > /dev/null 2>&1; then
  JPEG_CONVERT=(convert)
else
  echo "ImageMagick (magick or convert) needs to be installed to render the fullscreen previews."
  exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SASS_DIR="${REPO_DIR}/src/gtk/sass"
KDE_DIR="${REPO_DIR}/src/kde"
CS_DIR="${KDE_DIR}/color-schemes"
LNF_DIR="${KDE_DIR}/look-and-feel"
DT_DIR="${KDE_DIR}/desktoptheme"
AUR_BASE="${KDE_DIR}/aurorae-base"
AUR_DIR="${KDE_DIR}/aurorae"
DT_BASE="${KDE_DIR}/desktoptheme-base"
SDDM_BASE="${KDE_DIR}/sddm-base"
SDDM_DIR="${KDE_DIR}/sddm"
TEMPLATE="${KDE_DIR}/preview-template.svg"
SDDM_TEMPLATE="${KDE_DIR}/sddm-preview-template.svg"
SPLASH_TEMPLATE="${KDE_DIR}/splash-template.qml"

ID_PREFIX="com.github.zquestz."

TMP_DIR="$(mktemp -d)"
trap "rm -rf '${TMP_DIR}'" EXIT

mkdir -p "${CS_DIR}"
# Wipe old packages so renamed/removed folders never linger
rm -rf "${LNF_DIR}"
mkdir -p "${LNF_DIR}"
rm -rf "${DT_DIR}"
mkdir -p "${DT_DIR}"
rm -rf "${AUR_DIR}"
mkdir -p "${AUR_DIR}"
rm -rf "${SDDM_DIR}"
mkdir -p "${SDDM_DIR}"

# Number of resolved color keys the scheme emitter produces
EXPECTED_KEYS=100

write_scheme_scss() {
  local sass_variant="${1}"
  local sass_theme="${2}"
  local sass_header="${3}"

  {
    echo "\$variant: \"${sass_variant}\";"
    echo "\$color: \"${sass_theme}\";"
    echo "\$trans: \"true\";"
    echo "\$header: \"${sass_header}\";"
    cat << 'EOF'

@import "colors";

// Composite a translucent color over an opaque backdrop
@function flat($fg, $bg) {
  @return mix(rgb(red($fg), green($fg), blue($fg)), rgb(red($bg), green($bg), blue($bg)), alpha($fg) * 100%);
}

// Format a color as the decimal R,G,B triplet used by KDE color schemes
@function kde($c) {
  @return "#{round(red($c))},#{round(green($c))},#{round(blue($c))}";
}

$view_alt: if($variant == "light", darken($base_color, 3%), lighten($base_color, 3%));
$window_alt: if($variant == "light", darken($bg_color, 3%), lighten($bg_color, 3%));
$button_alt: if($variant == "light", darken($button_bg, 5%), lighten($button_bg, 5%));
$tooltip_bg: flat($osd_bg_color, $base_color);
$tooltip_alt: if($variant == "light", darken($tooltip_bg, 3%), lighten($tooltip_bg, 3%));
$compl_bg: flat($dark_sidebar_bg, $bg_color);
$compl_fg: $dark_sidebar_fg;
$compl_alt: if($variant == "light" and $header == "light", darken($compl_bg, 3%), lighten($compl_bg, 3%));
$header_alt: if($header == "light", darken($header_bg, 4%), lighten($header_bg, 4%));

$view_fg_inactive: flat($insensitive_fg_color, $base_color);
$window_fg_inactive: flat($insensitive_fg_color, $bg_color);
$button_fg_inactive: flat($insensitive_fg_color, $button_bg);
$selection_fg_inactive: flat(rgba($selected_fg_color, 0.7), $selected_bg_color);
$tooltip_fg_inactive: flat(rgba($osd_fg_color, 0.6), $tooltip_bg);
$compl_fg_inactive: flat(rgba($compl_fg, 0.55), $compl_bg);
$header_fg_inactive: flat(rgba($header_fg, 0.55), $header_bg);
$header_backdrop_fg: flat(rgba($header_fg, 0.6), $header_bg_backdrop);

$dark_surface_link: lighten($selected_bg_color, 20%);
$compl_link: if($variant == "light" and $header == "light", $link_color, $dark_surface_link);
$compl_visited: flat(rgba($compl_fg, 0.8), $compl_bg);
$header_link: if($header == "light", $link_color, $dark_surface_link);
$header_visited: if($header == "light", $link_visited_color, flat(rgba($header_fg, 0.8), $header_bg));

$selection_link: flat(rgba($selected_fg_color, 0.9), $selected_bg_color);
$selection_visited: flat(rgba($selected_fg_color, 0.75), $selected_bg_color);
$selection_negative: mix($error_color, $selected_fg_color, 70%);
$selection_neutral: mix($warning_color, $selected_fg_color, 70%);
$selection_positive: mix($success_color, $selected_fg_color, 70%);

scheme {
  ButtonBackgroundAlternate: #{kde($button_alt)};
  ButtonBackgroundNormal: #{kde($button_bg)};
  ButtonDecorationFocus: #{kde($selected_bg_color)};
  ButtonDecorationHover: #{kde($selected_bg_color)};
  ButtonForegroundActive: #{kde($selected_bg_color)};
  ButtonForegroundInactive: #{kde($button_fg_inactive)};
  ButtonForegroundLink: #{kde($link_color)};
  ButtonForegroundNegative: #{kde($error_color)};
  ButtonForegroundNeutral: #{kde($warning_color)};
  ButtonForegroundNormal: #{kde($fg_color)};
  ButtonForegroundPositive: #{kde($success_color)};
  ButtonForegroundVisited: #{kde($link_visited_color)};
  ComplementaryBackgroundAlternate: #{kde($compl_alt)};
  ComplementaryBackgroundNormal: #{kde($compl_bg)};
  ComplementaryDecorationFocus: #{kde($selected_bg_color)};
  ComplementaryDecorationHover: #{kde($selected_bg_color)};
  ComplementaryForegroundActive: #{kde($selected_bg_color)};
  ComplementaryForegroundInactive: #{kde($compl_fg_inactive)};
  ComplementaryForegroundLink: #{kde($compl_link)};
  ComplementaryForegroundNegative: #{kde($error_color)};
  ComplementaryForegroundNeutral: #{kde($warning_color)};
  ComplementaryForegroundNormal: #{kde($compl_fg)};
  ComplementaryForegroundPositive: #{kde($success_color)};
  ComplementaryForegroundVisited: #{kde($compl_visited)};
  HeaderBackgroundAlternate: #{kde($header_alt)};
  HeaderBackgroundNormal: #{kde($header_bg)};
  HeaderDecorationFocus: #{kde($selected_bg_color)};
  HeaderDecorationHover: #{kde($selected_bg_color)};
  HeaderForegroundActive: #{kde($selected_bg_color)};
  HeaderForegroundInactive: #{kde($header_fg_inactive)};
  HeaderForegroundLink: #{kde($header_link)};
  HeaderForegroundNegative: #{kde($error_color)};
  HeaderForegroundNeutral: #{kde($warning_color)};
  HeaderForegroundNormal: #{kde($header_fg)};
  HeaderForegroundPositive: #{kde($success_color)};
  HeaderForegroundVisited: #{kde($header_visited)};
  HeaderInactiveBackgroundAlternate: #{kde($header_bg_backdrop)};
  HeaderInactiveBackgroundNormal: #{kde($header_bg_backdrop)};
  HeaderInactiveDecorationFocus: #{kde($selected_bg_color)};
  HeaderInactiveDecorationHover: #{kde($selected_bg_color)};
  HeaderInactiveForegroundActive: #{kde($selected_bg_color)};
  HeaderInactiveForegroundInactive: #{kde($header_backdrop_fg)};
  HeaderInactiveForegroundLink: #{kde($header_link)};
  HeaderInactiveForegroundNegative: #{kde($error_color)};
  HeaderInactiveForegroundNeutral: #{kde($warning_color)};
  HeaderInactiveForegroundNormal: #{kde($header_backdrop_fg)};
  HeaderInactiveForegroundPositive: #{kde($success_color)};
  HeaderInactiveForegroundVisited: #{kde($header_visited)};
  SelectionBackgroundAlternate: #{kde($alt_selected_bg_color)};
  SelectionBackgroundNormal: #{kde($selected_bg_color)};
  SelectionDecorationFocus: #{kde($selected_bg_color)};
  SelectionDecorationHover: #{kde($selected_bg_color)};
  SelectionForegroundActive: #{kde($selected_fg_color)};
  SelectionForegroundInactive: #{kde($selection_fg_inactive)};
  SelectionForegroundLink: #{kde($selection_link)};
  SelectionForegroundNegative: #{kde($selection_negative)};
  SelectionForegroundNeutral: #{kde($selection_neutral)};
  SelectionForegroundNormal: #{kde($selected_fg_color)};
  SelectionForegroundPositive: #{kde($selection_positive)};
  SelectionForegroundVisited: #{kde($selection_visited)};
  TooltipBackgroundAlternate: #{kde($tooltip_alt)};
  TooltipBackgroundNormal: #{kde($tooltip_bg)};
  TooltipDecorationFocus: #{kde($selected_bg_color)};
  TooltipDecorationHover: #{kde($selected_bg_color)};
  TooltipForegroundActive: #{kde($selected_bg_color)};
  TooltipForegroundInactive: #{kde($tooltip_fg_inactive)};
  TooltipForegroundLink: #{kde($link_color)};
  TooltipForegroundNegative: #{kde($error_color)};
  TooltipForegroundNeutral: #{kde($warning_color)};
  TooltipForegroundNormal: #{kde($osd_fg_color)};
  TooltipForegroundPositive: #{kde($success_color)};
  TooltipForegroundVisited: #{kde($link_visited_color)};
  ViewBackgroundAlternate: #{kde($view_alt)};
  ViewBackgroundNormal: #{kde($base_color)};
  ViewDecorationFocus: #{kde($selected_bg_color)};
  ViewDecorationHover: #{kde($selected_bg_color)};
  ViewForegroundActive: #{kde($selected_bg_color)};
  ViewForegroundInactive: #{kde($view_fg_inactive)};
  ViewForegroundLink: #{kde($link_color)};
  ViewForegroundNegative: #{kde($error_color)};
  ViewForegroundNeutral: #{kde($warning_color)};
  ViewForegroundNormal: #{kde($fg_color)};
  ViewForegroundPositive: #{kde($success_color)};
  ViewForegroundVisited: #{kde($link_visited_color)};
  WindowBackgroundAlternate: #{kde($window_alt)};
  WindowBackgroundNormal: #{kde($bg_color)};
  WindowDecorationFocus: #{kde($selected_bg_color)};
  WindowDecorationHover: #{kde($selected_bg_color)};
  WindowForegroundActive: #{kde($selected_bg_color)};
  WindowForegroundInactive: #{kde($window_fg_inactive)};
  WindowForegroundLink: #{kde($link_color)};
  WindowForegroundNegative: #{kde($error_color)};
  WindowForegroundNeutral: #{kde($warning_color)};
  WindowForegroundNormal: #{kde($fg_color)};
  WindowForegroundPositive: #{kde($success_color)};
  WindowForegroundVisited: #{kde($link_visited_color)};
  WmActiveBackground: #{kde($header_bg)};
  WmActiveForeground: #{kde($header_fg)};
  WmInactiveBackground: #{kde($header_bg_backdrop)};
  WmInactiveForeground: #{kde($header_backdrop_fg)};
}
EOF
  } > "${TMP_DIR}/scheme.scss"
}

# Emit the handful of opaque colors the preview template needs, as TOKEN=#hex
write_preview_scss() {
  local sass_variant="${1}"
  local sass_theme="${2}"
  local sass_header="${3}"

  {
    echo "\$variant: \"${sass_variant}\";"
    echo "\$color: \"${sass_theme}\";"
    echo "\$trans: \"true\";"
    echo "\$header: \"${sass_header}\";"
    cat << 'EOF'

@import "colors";

// Composite a translucent color over an opaque backdrop
@function flat($fg, $bg) {
  @return mix(rgb(red($fg), green($fg), blue($fg)), rgb(red($bg), green($bg), blue($bg)), alpha($fg) * 100%);
}

preview {
  WALL1: $selected_bg_color;
  WALL2: darken($selected_bg_color, 28%);
  ACCENT: $selected_bg_color;
  PANEL: $panel_bg;
  HEADER: $header_bg;
  HEADERFG: $header_fg;
  HEADERBORDER: mix(black, $header_bg, if($header == "light", 15%, 25%));
  SPLASHTRACK: mix($header_fg, $header_bg, 25%);
  WINDOW: $bg_color;
  BASE: $base_color;
  FG: $fg_color;
  CLOSE: $wm_button_close_bg;
  COMPLBG: flat($dark_sidebar_bg, $bg_color);
  COMPLFG: $dark_sidebar_fg;
  COMPLDIM: flat(rgba($dark_sidebar_fg, 0.55), flat($dark_sidebar_bg, $bg_color));
  WINDIM: flat($insensitive_fg_color, $bg_color);
  SELFG: $selected_fg_color;
  ERROR: $error_color;
}
EOF
  } > "${TMP_DIR}/preview.scss"
}

write_color_group() {
  local out="${1}"
  local section="${2}"
  local prefix="${3}"

  {
    echo "${section}"
    echo "BackgroundAlternate=${C[${prefix}BackgroundAlternate]}"
    echo "BackgroundNormal=${C[${prefix}BackgroundNormal]}"
    echo "DecorationFocus=${C[${prefix}DecorationFocus]}"
    echo "DecorationHover=${C[${prefix}DecorationHover]}"
    echo "ForegroundActive=${C[${prefix}ForegroundActive]}"
    echo "ForegroundInactive=${C[${prefix}ForegroundInactive]}"
    echo "ForegroundLink=${C[${prefix}ForegroundLink]}"
    echo "ForegroundNegative=${C[${prefix}ForegroundNegative]}"
    echo "ForegroundNeutral=${C[${prefix}ForegroundNeutral]}"
    echo "ForegroundNormal=${C[${prefix}ForegroundNormal]}"
    echo "ForegroundPositive=${C[${prefix}ForegroundPositive]}"
    echo "ForegroundVisited=${C[${prefix}ForegroundVisited]}"
    echo ""
  } >> "${out}"
}

write_scheme() {
  local out="${1}"
  local scheme_id="${2}"
  local display_name="${3}"

  cat > "${out}" << EOF
[ColorEffects:Disabled]
Color=56,56,56
ColorAmount=0
ColorEffect=0
ContrastAmount=0.65
ContrastEffect=1
IntensityAmount=0.1
IntensityEffect=2

[ColorEffects:Inactive]
ChangeSelectionColor=true
Color=112,111,110
ColorAmount=0.025
ColorEffect=2
ContrastAmount=0.1
ContrastEffect=2
Enable=false
IntensityAmount=0
IntensityEffect=0

EOF

  write_color_group "${out}" "[Colors:Button]" "Button"
  write_color_group "${out}" "[Colors:Complementary]" "Complementary"
  write_color_group "${out}" "[Colors:Header]" "Header"
  write_color_group "${out}" "[Colors:Header][Inactive]" "HeaderInactive"
  write_color_group "${out}" "[Colors:Selection]" "Selection"
  write_color_group "${out}" "[Colors:Tooltip]" "Tooltip"
  write_color_group "${out}" "[Colors:View]" "View"
  write_color_group "${out}" "[Colors:Window]" "Window"

  cat >> "${out}" << EOF
[General]
ColorScheme=${scheme_id}
Name=${display_name}
shadeSortColumn=true

[KDE]
contrast=4

[WM]
activeBackground=${C[WmActiveBackground]}
activeBlend=${C[WmActiveBackground]}
activeForeground=${C[WmActiveForeground]}
inactiveBackground=${C[WmInactiveBackground]}
inactiveBlend=${C[WmInactiveBackground]}
inactiveForeground=${C[WmInactiveForeground]}
EOF
}

write_metadata() {
  local out="${1}"
  local pkg_id="${2}"
  local display_name="${3}"

  cat > "${out}" << EOF
{
    "KPackageStructure": "Plasma/LookAndFeel",
    "KPlugin": {
        "Authors": [
            {
                "Name": "zquestz"
            }
        ],
        "Category": "",
        "Description": "${display_name} global theme",
        "Id": "${pkg_id}",
        "License": "GPL-3.0-or-later",
        "Name": "${display_name}",
        "Website": "https://github.com/zquestz/celestial-gtk-theme"
    }
}
EOF
}

write_desktoptheme_metadata() {
  local out="${1}"
  local dt_id="${2}"
  local display_name="${dt_id//-/ }"

  cat > "${out}" << EOF
{
    "KPackageStructure": "Plasma/Theme",
    "KPlugin": {
        "Authors": [
            {
                "Name": "zquestz"
            }
        ],
        "Category": "",
        "Description": "Dark panel for the ${display_name} standard theme",
        "Id": "${dt_id}",
        "License": "GPL-3.0-or-later",
        "Name": "${display_name}",
        "Website": "https://github.com/zquestz/celestial-gtk-theme"
    }
}
EOF
}

write_defaults() {
  local out="${1}"
  local scheme_id="${2}"
  local plasma_theme="${3}"
  local icon_theme="${4}"
  local wallpaper="${5}"

  cat > "${out}" << EOF
[kdeglobals][KDE]
widgetStyle=kvantum

[kdeglobals][General]
ColorScheme=${scheme_id}

[kdeglobals][Icons]
Theme=${icon_theme}

[kcminputrc][Mouse]
cursorTheme=Celestial

[plasmarc][Theme]
name=${plasma_theme}

[kwinrc][org.kde.kdecoration2]
library=org.kde.kwin.aurorae.v2
theme=__aurorae__svg__${scheme_id}
BorderSize=Tiny

[ksplashrc][KSplash]
Theme=${ID_PREFIX}${scheme_id}

[Wallpaper]
Image=${wallpaper}
EOF
}

# Plasma desktop theme: Celestial's stylesheet-based widget set. The SVGs use
# ColorScheme-* classes, so Plasma recolors them at runtime from each variant's
# bundled colors file - no tokens needed.
build_desktoptheme() {
  local dest="${DT_DIR}/${scheme_id}"

  mkdir -p "${dest}"
  # No opaque/ variants: our surfaces are solid, so the normal files serve
  # both compositing states (Plasma falls back to them when opaque/ is absent)
  cp -r "${DT_BASE}/widgets" "${DT_BASE}/dialogs" "${dest}/"

  # Panel text needs light colors even on the light-bodied standard variants,
  # so standard bundles its color's dark scheme
  local colors_src="${CS_DIR}/${scheme_id}.colors"
  [[ "${mode}" == "standard" ]] && colors_src="${CS_DIR}/${scheme_id}-Dark.colors"
  cp "${colors_src}" "${dest}/colors"

  write_desktoptheme_metadata "${dest}/metadata.json" "${scheme_id}"
}

# Celestial splash screen: tokenized QML plus the Splash Screen KCM preview
render_splash() {
  local dir="${1}"

  mkdir -p "${dir}/splash"
  sed -e "s/{{HEADER}}/${P[HEADER]}/g" \
      -e "s/{{HEADERFG}}/${P[HEADERFG]}/g" \
      -e "s/{{SPLASHTRACK}}/${P[SPLASHTRACK]}/g" \
      -e "s/{{ACCENT}}/${P[ACCENT]}/g" \
      "${SPLASH_TEMPLATE}" > "${dir}/splash/Splash.qml"

  if grep -q '{{' "${dir}/splash/Splash.qml"; then
    echo "ERROR: unsubstituted splash token(s) for ${scheme_id}:" \
      "$(grep -o '{{[A-Z0-9]*}}' "${dir}/splash/Splash.qml" | sort -u | tr '\n' ' ')"
    exit 1
  fi

  # Splash preview for the Splash Screen KCM
  magick -size 300x169 "xc:${P[HEADER]}" \
    -fill "${P[HEADERFG]}" -gravity center -pointsize 22 -kerning 3 -annotate +0-10 "Celestial" \
    -fill "${P[SPLASHTRACK]}" -draw "roundrectangle 105,105 195,108 2,2" \
    -fill "${P[ACCENT]}" -draw "roundrectangle 105,105 150,108 2,2" \
    -strip "${dir}/previews/splash.png"
}

# Per-variant titlebutton colors, extracted from the GTK theme's rendered
# titlebutton assets (src/gtk/assets-<color>.svg). Standard and dark variants
# use the dark-header set; light variants use the light-header set. Re-extract
# if the GTK titlebutton designs ever change.
button_colors() {
  local key="${1}"

  case "${key}" in
    "sea|dark") CLOSEGLYPH="#959ba0"; GLYPH="#b9bcc2"; HOVERBG="#5f7d7c"; HOVEROP=".45"; HOVERGLYPH="#96aaa9"; PRESSBG="#2eb398" ;;
    "sea|light") CLOSEGLYPH="#515a59"; GLYPH="#515a59"; HOVERBG="#3c3c3c"; HOVEROP=".25"; HOVERGLYPH="#515a59"; PRESSBG="#2eb398" ;;
    "aliz|dark") CLOSEGLYPH="#c3c3c3"; GLYPH="#adadad"; HOVERBG="#838383"; HOVEROP=".45"; HOVERGLYPH="#b0b0b0"; PRESSBG="#ffffff" ;;
    "aliz|light") CLOSEGLYPH="#4d4d4d"; GLYPH="#4d4d4d"; HOVERBG="#565656"; HOVEROP=".25"; HOVERGLYPH="#4c4c4c"; PRESSBG="#808080" ;;
    "azul|dark") CLOSEGLYPH="#959ba0"; GLYPH="#828b98"; HOVERBG="#717e8a"; HOVEROP=".45"; HOVERGLYPH="#a9afbd"; PRESSBG="#3498db" ;;
    "azul|light") CLOSEGLYPH="#515a59"; GLYPH="#4e545e"; HOVERBG="#4d565f"; HOVEROP=".25"; HOVERGLYPH="#4b5161"; PRESSBG="#3498db" ;;
    "pueril|dark") CLOSEGLYPH="#c3c3c3"; GLYPH="#adadad"; HOVERBG="#838383"; HOVEROP=".45"; HOVERGLYPH="#b0b0b0"; PRESSBG="#ffffff" ;;
    "pueril|light") CLOSEGLYPH="#4d4d4d"; GLYPH="#4d4d4d"; HOVERBG="#565656"; HOVEROP=".25"; HOVERGLYPH="#4c4c4c"; PRESSBG="#808080" ;;
    *)
      echo "ERROR: no button colors for '${key}'."
      exit 1
      ;;
  esac
}

# SDDM login theme: tokenized Breeze QML (sddm-base/) with the palette baked
# in - the greeter has no color scheme configuration, so the Kirigami colors
# are pinned per variant at generation time. The KCM preview reuses the
# variant's look-and-feel preview image.
build_sddm() {
  local dest="${SDDM_DIR}/${scheme_id}"
  mkdir -p "${dest}/faces"

  cp "${SDDM_BASE}/Login.qml" "${SDDM_BASE}/Background.qml" "${dest}/"
  cp "${SDDM_BASE}/faces/.face.icon" "${dest}/faces/"

  local f
  for f in Main.qml SessionButton.qml KeyboardButton.qml theme.conf; do
    sed -e "s/{{COMPLBG}}/${P[COMPLBG]}/g" \
        -e "s/{{COMPLFG}}/${P[COMPLFG]}/g" \
        -e "s/{{COMPLDIM}}/${P[COMPLDIM]}/g" \
        -e "s/{{WINBG}}/${P[WINDOW]}/g" \
        -e "s/{{WINFG}}/${P[FG]}/g" \
        -e "s/{{WINDIM}}/${P[WINDIM]}/g" \
        -e "s/{{ACCENT}}/${P[ACCENT]}/g" \
        -e "s/{{SELFG}}/${P[SELFG]}/g" \
        -e "s/{{ERROR}}/${P[ERROR]}/g" \
        "${SDDM_BASE}/${f}.in" > "${dest}/${f}"
  done

  sed -e "s/{{DISPLAY}}/${display_name}/g" \
      -e "s/{{THEMEID}}/${scheme_id}/g" \
      "${SDDM_BASE}/metadata.desktop.in" > "${dest}/metadata.desktop"

  # KCM grid thumbnail: a schematic login screen in the variant's palette
  sed -e "s/{{WALL1}}/${P[WALL1]}/g" \
      -e "s/{{WALL2}}/${P[WALL2]}/g" \
      -e "s/{{COMPLFG}}/${P[COMPLFG]}/g" \
      -e "s/{{BASE}}/${P[BASE]}/g" \
      -e "s/{{ACCENT}}/${P[ACCENT]}/g" \
      -e "s/{{SELFG}}/${P[SELFG]}/g" \
      "${SDDM_TEMPLATE}" > "${TMP_DIR}/sddm-preview.svg"

  if grep -q '{{' "${TMP_DIR}/sddm-preview.svg"; then
    echo "ERROR: unsubstituted sddm preview token(s) for ${scheme_id}:" \
      "$(grep -o '{{[A-Z0-9]*}}' "${TMP_DIR}/sddm-preview.svg" | sort -u | tr '\n' ' ')"
    exit 1
  fi

  rsvg-convert -w 600 -h 337 "${TMP_DIR}/sddm-preview.svg" -o "${dest}/preview.png" || exit 1
  if [ "$(which optipng 2> /dev/null)" ]; then
    optipng -quiet -o2 "${dest}/preview.png" > /dev/null 2>&1
  fi

  if grep -rIq '{{' "${dest}"; then
    echo "ERROR: unsubstituted sddm token(s) for ${scheme_id}:" \
      "$(grep -rIho '{{[A-Z]*}}' "${dest}" | sort -u | tr '\n' ' ')"
    exit 1
  fi
}

build_aurorae() {
  local dest="${AUR_DIR}/${scheme_id}"
  local bmode="dark"
  [[ "${mode}" == "light" ]] && bmode="light"

  mkdir -p "${dest}"
  button_colors "${theme}|${bmode}"

  local -a S=(
    -e "s/{{HEADERBG}}/${P[HEADER]}/g"
    -e "s/{{HEADERBORDER}}/${P[HEADERBORDER]}/g"
    -e "s/{{CLOSEGLYPH}}/${CLOSEGLYPH}/g"
    -e "s/{{GLYPH}}/${GLYPH}/g"
    -e "s/{{HOVERBG}}/${HOVERBG}/g"
    -e "s/{{HOVEROP}}/${HOVEROP}/g"
    -e "s/{{HOVERGLYPH}}/${HOVERGLYPH}/g"
    -e "s/{{PRESSBG}}/${PRESSBG}/g"
  )

  sed "${S[@]}" "${AUR_BASE}/${bmode}/decoration.svg.in" > "${dest}/decoration.svg"

  local tpl
  for tpl in "${AUR_BASE}"/buttons/*.svg.in; do
    sed "${S[@]}" "${tpl}" > "${dest}/$(basename "${tpl%.in}")"
  done

  if grep -rq '{{' "${dest}"; then
    echo "ERROR: unsubstituted aurorae token(s) for ${scheme_id}:" \
      "$(grep -rho '{{[A-Z0-9]*}}' "${dest}" | sort -u | tr '\n' ' ')"
    exit 1
  fi

  cat > "${dest}/${scheme_id}rc" << EOF
[General]
ActiveTextColor=${C[WmActiveForeground]}
InactiveTextColor=${C[HeaderInactiveForegroundNormal]}
Animation=0
LeftButtons=
RightButtons=IAX
Shadow=false
TitleAlignment=Center
TitleVerticalAlignment=Center
UseTextShadow=false

[Layout]
BorderBottom=1
BorderLeft=1
BorderRight=1
ButtonHeight=22
ButtonMarginTop=0
ButtonSpacing=8
ButtonWidth=22
ExplicitButtonSpacer=10
PaddingBottom=10
PaddingLeft=10
PaddingRight=10
PaddingTop=10
TitleBorderLeft=1
TitleBorderRight=1
TitleEdgeBottom=3
TitleEdgeBottomMaximized=3
TitleEdgeLeft=5
TitleEdgeLeftMaximized=5
TitleEdgeRight=5
TitleEdgeRightMaximized=5
TitleEdgeTop=3
TitleEdgeTopMaximized=3
TitleHeight=15
EOF

  cat > "${dest}/metadata.desktop" << EOF
[Desktop Entry]
Name=${display_name}
X-KDE-PluginInfo-Author=zquestz
X-KDE-PluginInfo-Category=
X-KDE-PluginInfo-EnabledByDefault=true
X-KDE-PluginInfo-License=GPL v3
X-KDE-PluginInfo-Name=${scheme_id}
X-KDE-PluginInfo-Website=https://github.com/zquestz/celestial-gtk-theme
EOF
}

render_previews() {
  local dir="${1}"

  write_preview_scss "${sass_variant}" "${theme}" "${sass_header}"
  sassc -t expanded -I "${SASS_DIR}" "${TMP_DIR}/preview.scss" "${TMP_DIR}/preview.css" || exit 1

  cp "${TEMPLATE}" "${TMP_DIR}/preview.svg"
  while IFS='=' read -r token value; do
    P["${token}"]="${value}"
    sed -i "s|{{${token}}}|${value}|g" "${TMP_DIR}/preview.svg"
  done < <(sed -n 's/^ *\([A-Z0-9]\+\): \(#[0-9a-fA-F]*\);$/\1=\2/p' "${TMP_DIR}/preview.css")

  if grep -q '{{' "${TMP_DIR}/preview.svg"; then
    echo "ERROR: unsubstituted preview token(s) for ${scheme_id}:" \
      "$(grep -o '{{[A-Z0-9]*}}' "${TMP_DIR}/preview.svg" | sort -u | tr '\n' ' ')"
    exit 1
  fi

  # Grid thumbnail
  rsvg-convert -w 600 -h 337 "${TMP_DIR}/preview.svg" -o "${dir}/preview.png" || exit 1
  if [ "$(which optipng 2> /dev/null)" ]; then
    optipng -quiet -o2 "${dir}/preview.png" > /dev/null 2>&1
  fi

  # Fullscreen preview (the KCM's "Show Preview"); the package structure expects
  # this exact JPEG path, so rsvg to PNG then convert to JPEG
  rsvg-convert -w 1920 -h 1080 "${TMP_DIR}/preview.svg" -o "${TMP_DIR}/fullscreen.png" || exit 1
  "${JPEG_CONVERT[@]}" "${TMP_DIR}/fullscreen.png" -quality 88 "${dir}/fullscreenpreview.jpg" || exit 1
}

for theme in sea aliz azul pueril; do
  # dark first: the standard variant's desktop theme bundles the dark color scheme
  for mode in dark light standard; do
    case "${mode}" in
      standard)
        sass_variant="light"
        sass_header="dark"
        suffix=""
        icon_theme="Papirus"
        ;;
      light)
        sass_variant="light"
        sass_header="light"
        suffix="-Light"
        icon_theme="Papirus-Light"
        ;;
      dark)
        sass_variant="dark"
        sass_header="dark"
        suffix="-Dark"
        icon_theme="Papirus-Dark"
        ;;
    esac

    theme_cap="${theme^}"
    scheme_id="Celestial-${theme_cap}${suffix}"
    display_name="${scheme_id//-/ }"
    pkg_id="${ID_PREFIX}${scheme_id}"
    pkg_dir="${LNF_DIR}/${pkg_id}"

    # Every variant ships its own Celestial desktop theme (panel, popups, tooltip)
    plasma_theme="${scheme_id}"

    # Each color's default wallpaper (Plasma wallpaper packages installed by -b)
    case "${theme}" in
      sea) wallpaper="Celestial-Sea-Bioluminescence" ;;
      aliz) wallpaper="Celestial-Aliz-Temple" ;;
      azul) wallpaper="Celestial-Azul-Ice" ;;
      pueril) wallpaper="Celestial-Pueril-Bamboo" ;;
    esac

    # Color scheme
    write_scheme_scss "${sass_variant}" "${theme}" "${sass_header}"
    sassc -t expanded -I "${SASS_DIR}" "${TMP_DIR}/scheme.scss" "${TMP_DIR}/scheme.css" || exit 1

    unset C P
    declare -A C P
    while IFS='=' read -r key value; do
      C["${key}"]="${value}"
    done < <(sed -n 's/^ *\([A-Za-z]\+\): \(.*\);$/\1=\2/p' "${TMP_DIR}/scheme.css")

    if [[ "${#C[@]}" -ne "${EXPECTED_KEYS}" ]]; then
      echo "ERROR: expected ${EXPECTED_KEYS} resolved colors for ${scheme_id}, got ${#C[@]}."
      exit 1
    fi

    echo "==> ${scheme_id}.colors"
    write_scheme "${CS_DIR}/${scheme_id}.colors" "${scheme_id}" "${display_name}"

    # Global theme package (folder name == Id)
    echo "==> ${pkg_id}"
    mkdir -p "${pkg_dir}/contents/previews"
    write_metadata "${pkg_dir}/metadata.json" "${pkg_id}" "${display_name}"
    write_defaults "${pkg_dir}/contents/defaults" "${scheme_id}" "${plasma_theme}" "${icon_theme}" "${wallpaper}"
    # Bundle the color scheme so applying the global theme merges the colors
    # (the ColorScheme= label alone does not apply them)
    cp "${CS_DIR}/${scheme_id}.colors" "${pkg_dir}/contents/colors"
    render_previews "${pkg_dir}/contents/previews"
    render_splash "${pkg_dir}/contents"

    # Window decoration (Aurorae package)
    build_aurorae

    # Plasma desktop theme (panel, popups, tooltip)
    build_desktoptheme

    build_sddm
  done
done
