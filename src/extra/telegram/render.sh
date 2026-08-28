#! /usr/bin/env bash
# shellcheck disable=SC2064,SC2001
# Generates the Celestial Telegram Desktop palettes from the GTK sass palette.
#
# Upstream's own theme-authoring bases live unmodified in base/ (day for the
# light variants, night for the dark ones), so anything we do not set - the
# group member colors, file type colors, call buttons - keeps the value
# Telegram designed for that mode.
#
# The override table below is the theme: message surfaces stay neutral with a
# hint of the variant's accent, and the accent itself is reserved for links
# and controls.
#
# Each theme is packaged as a .tdesktop-theme (a zip of the palette plus a flat
# chat background), because applying a bare palette leaves Telegram's patterned
# default wallpaper behind the messages.
#
# Run this after changing src/gtk/sass/_colors.scss, then commit the outputs.

if [ ! "$(which sassc 2> /dev/null)" ]; then
  echo sassc needs to be installed to generate the palettes.
  exit 1
fi

if [ ! "$(which zip 2> /dev/null)" ]; then
  echo zip needs to be installed to package the themes.
  exit 1
fi

if command -v magick > /dev/null 2>&1; then
  IMAGE_CONVERT=(magick)
elif command -v convert > /dev/null 2>&1; then
  IMAGE_CONVERT=(convert)
else
  echo "ImageMagick (magick or convert) needs to be installed to render the chat background."
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}" || exit 1

SASS_DIR="../../gtk/sass"
BASE_DIR="base"

TMP_DIR="$(mktemp -d)"
trap "rm -rf '${TMP_DIR}'" EXIT

THEMES=(sea aliz azul pueril)
MODES=(light dark)

# Colors we derive from the GTK palette. Everything the override table uses
# has to appear here.
write_scss() {
  local variant="${1}"
  local theme="${2}"

  {
    echo "\$variant: \"${variant}\";"
    echo "\$color: \"${theme}\";"
    echo "\$trans: \"true\";"
    echo "\$header: \"${variant}\";"
    cat << 'EOF'

@import "colors";

// Composite a translucent color over an opaque backdrop
@function flat($fg, $bg) {
  @return mix(rgb(red($fg), green($fg), blue($fg)), rgb(red($bg), green($bg), blue($bg)), alpha($fg) * 100%);
}

// Step a surface away from the window background: lighter on dark variants,
// darker on light ones
@function raise($c, $amount) {
  @return if($variant == "light", darken($c, $amount), lighten($c, $amount));
}

$light: $variant == "light";
$dim: flat($insensitive_fg_color, $bg_color);

// Message surfaces: neutral, separated by elevation, with just enough accent
// in the outgoing bubble to tell the variants apart
$in_bg: $base_color;
$out_bg: mix($selected_bg_color, raise($base_color, 4%), 10%);

palette {
  BG: $bg_color;
  BASE: $base_color;
  RAISED: raise($bg_color, 4%);
  OVER: raise($bg_color, 6%);
  RIPPLE: raise($bg_color, 10%);
  FG: $fg_color;
  DIM: $dim;
  DIM2: mix($fg_color, $dim, 25%);
  DISABLED: mix($dim, $bg_color, 55%);
  BORDER: raise($bg_color, 12%);
  ACCENT: $selected_bg_color;
  ACCENTOVER: raise($selected_bg_color, 4%);
  ACCENTRIPPLE: raise($selected_bg_color, 9%);
  ACCENTSOFT: mix($selected_bg_color, $bg_color, 12%);
  ACCENTSOFT2: mix($selected_bg_color, $bg_color, 20%);
  SELFG: $selected_fg_color;
  SELSOFT: mix($selected_fg_color, $selected_bg_color, 75%);
  LINK: $link_color;
  ERROR: $error_color;
  ERRORSOFT: mix($error_color, $bg_color, 12%);
  ERRORSOFT2: mix($error_color, $bg_color, 20%);
  OK: $success_color;
  WARN: $warning_color;
  TOOLTIPBG: raise($base_color, 3%);
  INBG: $in_bg;
  INSEL: mix($selected_bg_color, $in_bg, 22%);
  OUTBG: $out_bg;
  OUTSEL: mix($selected_bg_color, $out_bg, 25%);
  MONO: mix($selected_bg_color, $fg_color, 35%);
  WAVEIN: mix($fg_color, $in_bg, 25%);
  WAVEOUT: mix($fg_color, $out_bg, 30%);
  UNREADBAR: raise($bg_color, 3%);
}
EOF
  } > "${TMP_DIR}/palette.scss"
}

# telegram key -> token emitted above
declare -a MAP=(
  # window chrome
  "windowBg=BG"
  "windowFg=FG"
  "windowBgOver=OVER"
  "windowBgRipple=RIPPLE"
  "windowSubTextFg=DIM"
  "windowSubTextFgOver=DIM2"
  "windowBoldFg=FG"
  "windowBoldFgOver=FG"
  "windowBgActive=ACCENT"
  "windowActiveTextFg=LINK"
  "windowShadowFgFallback=OVER"
  # buttons
  "activeButtonBg=ACCENT"
  "activeButtonBgOver=ACCENTOVER"
  "activeButtonBgRipple=ACCENTRIPPLE"
  "activeButtonSecondaryFg=SELSOFT"
  "activeLineFg=ACCENT"
  "activeLineFgError=ERROR"
  "lightButtonBgOver=ACCENTSOFT"
  "lightButtonBgRipple=ACCENTSOFT2"
  "attentionButtonFg=ERROR"
  "attentionButtonFgOver=ERROR"
  "attentionButtonBgOver=ERRORSOFT"
  "attentionButtonBgRipple=ERRORSOFT2"
  # menus
  "menuIconFg=DIM"
  "menuIconFgOver=DIM2"
  "menuSubmenuArrowFg=FG"
  "menuFgDisabled=DISABLED"
  "menuSeparatorFg=BORDER"
  # inputs
  "placeholderFgActive=DISABLED"
  "inputBorderFg=BORDER"
  "filterInputBorderFg=ACCENT"
  "checkboxFg=DIM"
  "sliderBgInactive=BORDER"
  "sliderBgActive=ACCENT"
  # tooltips
  "tooltipBg=TOOLTIPBG"
  "tooltipFg=FG"
  "tooltipBorderFg=BORDER"
  # window title
  "titleButtonFg=DIM"
  "titleButtonFgOver=FG"
  "titleButtonBgOver=OVER"
  "titleButtonCloseBgOver=ERROR"
  "titleFg=DIM"
  "titleFgActive=FG"
  # boxes
  "boxTitleFg=FG"
  "boxTitleAdditionalFg=DIM"
  "boxTextFgGood=OK"
  "boxTextFgError=ERROR"
  # chat list
  "dialogsBgActive=ACCENT"
  "dialogsDraftFgActive=SELSOFT"
  "dialogsDraftFg=ERROR"
  "dialogsSentIconFg=ACCENT"
  "dialogsSentIconFgOver=ACCENT"
  "dialogsOnlineBadgeFg=OK"
  "dialogsUnreadBgMuted=DIM"
  "dialogsVerifiedIconBg=ACCENT"
  "dialogsVerifiedIconBgOver=ACCENT"
  "dialogsArchiveFg=DIM"
  "dialogsArchiveFgOver=DIM2"
  "dialogsSendingIconFg=DISABLED"
  # emoji / sticker panel
  "emojiPanCategories=RAISED"
  "emojiIconFg=DIM"
  "emojiIconFgActive=ACCENT"
  # message bubbles
  "msgInBg=INBG"
  "msgInBgSelected=INSEL"
  "msgOutBg=OUTBG"
  "msgOutBgSelected=OUTSEL"
  "msgInDateFg=DIM"
  "msgInDateFgSelected=DIM2"
  "msgOutDateFg=DIM"
  "msgOutDateFgSelected=DIM2"
  "msgInServiceFg=LINK"
  "msgInServiceFgSelected=LINK"
  "msgOutServiceFg=LINK"
  "msgOutServiceFgSelected=LINK"
  "msgInMonoFg=MONO"
  "msgOutMonoFg=MONO"
  "msgOutReplyBarColor=ACCENT"
  "msgOutReplyBarSelColor=ACCENT"
  "msgFileOutBg=ACCENT"
  "msgFileOutBgOver=ACCENTOVER"
  "msgFileOutBgSelected=ACCENTRIPPLE"
  "msgFileInBgOver=ACCENTOVER"
  "msgFileInBgSelected=ACCENTRIPPLE"
  "msgFileThumbLinkOutFg=LINK"
  "msgFileThumbLinkOutFgSelected=LINK"
  "msgWaveformInActiveSelected=ACCENTOVER"
  "msgWaveformInInactive=WAVEIN"
  "msgWaveformInInactiveSelected=WAVEIN"
  "msgWaveformOutActive=ACCENT"
  "msgWaveformOutActiveSelected=ACCENTOVER"
  "msgWaveformOutInactive=WAVEOUT"
  "msgWaveformOutInactiveSelected=WAVEOUT"
  # history chrome
  "historyOutIconFg=ACCENT"
  "historyOutIconFgSelected=ACCENTOVER"
  "historyLinkOutFg=LINK"
  "historyLinkOutFgSelected=LINK"
  "historySendingOutIconFg=DISABLED"
  "historySendingInIconFg=DISABLED"
  "historyUnreadBarBg=UNREADBAR"
  "historyUnreadBarFg=DIM"
  "historySendIconFg=ACCENT"
  "historySendIconFgOver=ACCENTOVER"
  "historyReplyIconFg=ACCENT"
  # side bar (folders column)
  "sideBarBg=RAISED"
  "sideBarBgActive=BG"
  "sideBarBgRipple=RIPPLE"
  "sideBarTextFg=DIM"
  "sideBarIconFg=DIM"
  "sideBarBadgeBg=ACCENT"
  "sideBarBadgeBgMuted=DIM"
  # profile / misc
  "profileStatusFgOver=DIM2"
  "mainMenuCloudBg=ACCENT"
  "mediaPlayerActiveFg=ACCENT"
  "mediaPlayerInactiveFg=BORDER"
  "notificationSampleUserpicFg=ACCENT"
)

render() {
  local mode="${1}"
  local theme="${2}"
  local base theme_cap color_cap out
  base="${BASE_DIR}/$([[ "${mode}" == "light" ]] && echo day || echo night).tdesktop-palette"
  theme_cap="$(echo "${theme}" | sed 's/.*/\u&/')"
  color_cap="$(echo "${mode}" | sed 's/.*/\u&/')"
  out="${SCRIPT_DIR}/Celestial-${theme_cap}-${color_cap}.tdesktop-theme"

  write_scss "${mode}" "${theme}"
  sassc -t expanded -I "${SASS_DIR}" "${TMP_DIR}/palette.scss" "${TMP_DIR}/palette.css" || exit 1

  declare -A P
  while IFS='=' read -r token value; do
    P["${token}"]="${value}"
  done < <(sed -n 's/^ *\([A-Z0-9]\+\): \(.*\);$/\1=\2/p' "${TMP_DIR}/palette.css")

  # token name -> resolved color, keyed by telegram entry
  : > "${TMP_DIR}/overrides"
  local pair key token
  for pair in "${MAP[@]}"; do
    key="${pair%%=*}"
    token="${pair##*=}"
    if [[ -z "${P[${token}]:-}" ]]; then
      echo "ERROR: token '${token}' (for ${key}) missing from the compiled palette"
      exit 1
    fi
    echo "${key}=${P[${token}]}" >> "${TMP_DIR}/overrides"
  done

  awk -F= 'NR==FNR { o[$1]=$2; next }
    {
      line = $0
      key = line
      sub(/:.*/, "", key)
      if (key in o) {
        comment = ""
        if (match(line, /\/\/.*/)) comment = " " substr(line, RSTART)
        print key ": " o[key] ";" comment
      } else {
        print line
      }
    }' "${TMP_DIR}/overrides" "${base}" > "${TMP_DIR}/colors.tdesktop-palette"

  # A flat chat background so the messages sit on a Celestial surface instead
  # of Telegram's patterned default
  "${IMAGE_CONVERT[@]}" -size 1920x1080 "xc:${P[BG]}" -strip "${TMP_DIR}/background.jpg" || exit 1

  # Fixed timestamps keep the archive reproducible across runs
  touch -t 202601010000 "${TMP_DIR}/colors.tdesktop-palette" "${TMP_DIR}/background.jpg"
  rm -f "${out}"
  (cd "${TMP_DIR}" && zip -X -q "${out}" colors.tdesktop-palette background.jpg) || exit 1

  echo "==> $(basename "${out}")"
}

for mode in "${MODES[@]}"; do
  for theme in "${THEMES[@]}"; do
    render "${mode}" "${theme}"
  done
done
