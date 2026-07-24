#! /usr/bin/env bash
# shellcheck disable=SC2086,SC2001
# Celestial GTK Theme Installer
# Version: 1.5.0

ROOT_UID=0
DEST_DIR=
DESTDIR="${DESTDIR:-}"

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/themes"
  GTKSV_DIR="/usr/share/gtksourceview-4/styles"
  KVANTUM_DIR="/usr/share/Kvantum"
  COLOR_SCHEMES_DIR="/usr/share/color-schemes"
  PLASMA_LNF_DIR="/usr/share/plasma/look-and-feel"
  PLASMA_THEME_DIR="/usr/share/plasma/desktoptheme"
  AURORAE_DIR="/usr/share/aurorae/themes"
  WALLPAPERS_DIR="/usr/share/wallpapers"
  KONSOLE_DIR="/usr/share/konsole"
  BG_DIR="/usr/share/backgrounds/celestial"
  BG_PROPS_DIRS=(
    "/usr/share/gnome-background-properties"
    "/usr/share/mate-background-properties"
    "/usr/share/cinnamon-background-properties"
  )
  GHOSTTY_DIR="/usr/share/ghostty/themes"
  COPYQ_DIR="/usr/share/copyq/themes"
  CURSORS_DIR="/usr/share/icons"
  KITTY_DIR=""
  ZED_DIR=""
  HALLOY_DIR=""
else
  DEST_DIR="$HOME/.themes"
  GTKSV_DIR="$HOME/.local/share/gtksourceview-4/styles"
  KVANTUM_DIR="$HOME/.config/Kvantum"
  COLOR_SCHEMES_DIR="$HOME/.local/share/color-schemes"
  PLASMA_LNF_DIR="$HOME/.local/share/plasma/look-and-feel"
  PLASMA_THEME_DIR="$HOME/.local/share/plasma/desktoptheme"
  AURORAE_DIR="$HOME/.local/share/aurorae/themes"
  WALLPAPERS_DIR="$HOME/.local/share/wallpapers"
  KONSOLE_DIR="$HOME/.local/share/konsole"
  BG_DIR="$HOME/.local/share/backgrounds/celestial"
  BG_PROPS_DIRS=(
    "$HOME/.local/share/gnome-background-properties"
    "$HOME/.local/share/mate-background-properties"
    "$HOME/.local/share/cinnamon-background-properties"
  )
  GHOSTTY_DIR="$HOME/.config/ghostty/themes"
  COPYQ_DIR="$HOME/.config/copyq/themes"
  CURSORS_DIR="$HOME/.local/share/icons"
  KITTY_DIR="$HOME/.config/kitty/themes"
  ZED_DIR="$HOME/.config/zed/themes"
  HALLOY_DIR="$HOME/.config/halloy/themes"
fi

REO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="${REO_DIR}/src"

THEME_NAME=Celestial
COLOR_VARIANTS=('' '-light' '-dark')
THEME_VARIANTS=('-sea' '-aliz' '-azul' '-pueril')

SHELL_VERSION=""

usage() {
  printf "%s\n" "Celestial GTK Theme Installer v1.5.0"
  printf "%s\n" "Usage: $0 [OPTIONS...]"
  printf "\n%s\n" "OPTIONS:"
  printf "  %-25s%s\n" "-d, --dest DIR" "Destination directory (Default: ${DEST_DIR})"
  printf "  %-25s%s\n" "-n, --name NAME" "Theme name (Default: ${THEME_NAME})"
  printf "  %-25s%s\n" "-c, --color VARIANTS" "Color variant [standard|light|dark] (Default: All)"
  printf "  %-25s%s\n" "-t, --theme VARIANTS" "Theme variant [sea|aliz|azul|pueril] (Default: All)"
  printf "  %-25s%s\n" "-s, --gnome-shell" "GNOME Shell version [38|40|42|44|46|47|48] (Default: Auto)"
  printf "  %-25s%s\n" "-l, --libadwaita" "Link libadwaita apps to GTK-4.0 theme"
  printf "  %-25s%s\n" "-k, --kvantum" "Install Kvantum theme for Qt applications"
  printf "  %-25s%s\n" "-b, --backgrounds" "Install theme backgrounds"
  printf "  %-25s%s\n" "--copyq" "Install CopyQ clipboard manager themes"
  printf "  %-25s%s\n" "--cursors" "Install Celestial cursor theme"
  printf "  %-25s%s\n" "--ghostty" "Install Ghostty terminal theme"
  printf "  %-25s%s\n" "--halloy" "Install Halloy IRC client themes"
  printf "  %-25s%s\n" "--kde" "Install KDE Plasma themes"
  printf "  %-25s%s\n" "--kitty" "Install Kitty terminal theme"
  printf "  %-25s%s\n" "--zed" "Install Zed editor themes"
  printf "  %-25s%s\n" "-g, --gdm" "Install GDM theme (requires sudo)"
  printf "  %-25s%s\n" "-r, --remove" "Uninstall theme"
  printf "  %-25s%s\n" "-h, --help" "Show this help"
}

# Copying files
install() {
  local dest="${1}"
  local name="${2}"
  local theme="${3}"
  local color="${4}"

  # Capitalize theme and color for display names
  local theme_cap=""
  local color_cap=""

  if [[ -n "${theme}" ]]; then
    theme_cap="-$(echo "${theme#-}" | sed 's/.*/\u&/')"
  fi

  if [[ -n "${color}" ]]; then
    color_cap="-$(echo "${color#-}" | sed 's/.*/\u&/')"
  fi

  local themedir="${DESTDIR}${dest}/${name}${theme_cap}${color_cap}"
  local hdpithemedir="${DESTDIR}${dest}/${name}${theme_cap}${color_cap}-hdpi"
  local xhdpithemedir="${DESTDIR}${dest}/${name}${theme_cap}${color_cap}-xhdpi"

  [[ ${color} == '-dark' ]] && local ELSE_DARK="${color}"
  # ELSE_LIGHT is set but not currently used in theme files
  # shellcheck disable=SC2034
  [[ ${color} == '-light' ]] && local ELSE_LIGHT="${color}"

  [[ -d "${themedir}" ]] && rm -rf "${themedir}"

  echo "Installing '${themedir}'..."
  mkdir -p                                                                            "${themedir}"

  # Icon pairing: Papirus for standard, Papirus-Dark/-Light for dark/light
  local icon_theme="Papirus"
  [[ "${color}" == "-dark" ]] && icon_theme="Papirus-Dark"
  [[ "${color}" == "-light" ]] && icon_theme="Papirus-Light"

  # Install index.theme
  {
    echo "[Desktop Entry]"
    echo "Type=X-GNOME-Metatheme"
    echo "Name=${name}${theme_cap}${color_cap}"
    echo "Comment=A dark modern design theme"
    echo "Encoding=UTF-8"
    echo ""
    echo "[X-GNOME-Metatheme]"
    echo "GtkTheme=${name}${theme_cap}${color_cap}"
    echo "MetacityTheme=${name}${theme_cap}${color_cap}"
    echo "IconTheme=${icon_theme}"
    echo "CursorTheme=Celestial"
    echo "ButtonLayout=menu:minimize,maximize,close"
  } >> "${themedir}/index.theme"

  # Install GNOME Shell Theme
  mkdir -p                                                                            "${themedir}/gnome-shell"
  cd "${SRC_DIR}/gnome-shell" || return
  cp -r pad-osd.css                                                                   "${themedir}/gnome-shell"
  cp -r icons                                                                         "${themedir}/gnome-shell"
  cp -r ./*.svg                                                                       "${themedir}/gnome-shell"
  cp -r common-assets                                                                 "${themedir}/gnome-shell/assets"
  cp -r "assets${ELSE_DARK}"/*.svg                                                    "${themedir}/gnome-shell/assets"
  cp -r "${SHELL_VERSION}/gnome-shell${theme}${ELSE_DARK}.css"                        "${themedir}/gnome-shell/gnome-shell.css"

  cd "${SRC_DIR}/gnome-shell/theme-assets" || return
  cp -r "checkbox${theme}.svg"                                                        "${themedir}/gnome-shell/assets/checkbox.svg"
  cp -r "more-results${theme}.svg"                                                    "${themedir}/gnome-shell/assets/more-results.svg"
  cp -r "toggle-on${theme}${ELSE_DARK}.svg"                                           "${themedir}/gnome-shell/assets/toggle-on.svg"

  # Install GTK+ 2.0 Theme
  mkdir -p                                                                            "${themedir}/gtk-2.0"
  cd "${SRC_DIR}/gtk-2.0" || return
  cp -r {apps.rc,main.rc,panel.rc,xfce-notify.rc}                                     "${themedir}/gtk-2.0"
  cp -r "gtkrc${theme}${color}"                                                       "${themedir}/gtk-2.0/gtkrc"
  cp -r "assets${theme}${ELSE_DARK}"                                                  "${themedir}/gtk-2.0/assets"
  cp -r "menubar-toolbar${ELSE_DARK}.rc"                                              "${themedir}/gtk-2.0/menubar-toolbar.rc"

  # Install GTK+ 3.0 Theme
  mkdir -p                                                                            "${themedir}/gtk-3.0"
  cd "${SRC_DIR}/gtk" || return
  cp -r "assets${theme}"                                                              "${themedir}/gtk-3.0/assets"
  cp -r "gtk-3.0/gtk${theme}${color}.css"                                             "${themedir}/gtk-3.0/gtk.css"
  cp -r "gtk-3.0/gtk${theme}-dark.css"                                                "${themedir}/gtk-3.0/gtk-dark.css"

  cp -r "thumbnail${theme}${ELSE_DARK}.png"                                           "${themedir}/gtk-3.0/thumbnail.png"

  # Install GTK+ 4.0 Theme
  mkdir -p                                                                            "${themedir}/gtk-4.0"
  cp -r "gtk-4.0/gtk${theme}${color}.css"                                             "${themedir}/gtk-4.0/gtk.css"
  cp -r "gtk-4.0/gtk${theme}-dark.css"                                                "${themedir}/gtk-4.0/gtk-dark.css"
  cd "${themedir}/gtk-4.0" || return
  ln -sf ../gtk-3.0/assets  assets
  ln -sf ../gtk-3.0/thumbnail.png thumbnail.png

  # Install CINNAMON Theme
  mkdir -p                                                                            "${themedir}/cinnamon"
  cd "${SRC_DIR}/cinnamon" || return
  cp -r "cinnamon${theme}${ELSE_DARK}.css"                                            "${themedir}/cinnamon/cinnamon.css"
  cp -r "thumbnail${theme}${ELSE_DARK}.png"                                           "${themedir}/cinnamon/thumbnail.png"

  cd "${SRC_DIR}/cinnamon/assets${theme}" || return
  cp -r common-assets/*                                                               "${themedir}/cinnamon"
  cp -r "assets${ELSE_DARK}"/*                                                        "${themedir}/cinnamon"

  # Install Metacity Theme
  mkdir -p                                                                            "${themedir}/metacity-1"
  cd "${SRC_DIR}/metacity-1" || return
  cp -r {thumbnail.png,*.svg,metacity-theme-3.xml}                                    "${themedir}/metacity-1"
  cp -r "metacity-theme-1${theme}.xml"                                                "${themedir}/metacity-1/metacity-theme-1.xml"

  cd "${themedir}/metacity-1" || return
  ln -s metacity-theme-1.xml metacity-theme-2.xml

  # Install xfwm4 Theme
  mkdir -p                                                                            "${themedir}/xfwm4"
  cd "${SRC_DIR}/xfwm4" || return
  cp -r "assets${theme}${color}"/*.png                                                "${themedir}/xfwm4"

  if [[ "${color}" == '-light' ]] ; then
    cp -r "themerc${color}"                                                           "${themedir}/xfwm4/themerc"
  else
    cp -r "themerc${theme}"                                                           "${themedir}/xfwm4/themerc"
  fi

  # Install xfwm4 hdpi Theme
  mkdir -p                                                                            "${hdpithemedir}/xfwm4"
  cp -r "assets${theme}-hdpi${color}"/*.png                                           "${hdpithemedir}/xfwm4"

  if [[ "${color}" == '-light' ]] ; then
    cp -r "themerc${color}"                                                           "${hdpithemedir}/xfwm4/themerc"
  else
    cp -r "themerc${theme}"                                                           "${hdpithemedir}/xfwm4/themerc"
  fi

  # Install xfwm4 xhdpi Theme
  mkdir -p                                                                            "${xhdpithemedir}/xfwm4"
  cp -r "assets${theme}-xhdpi${color}"/*.png                                          "${xhdpithemedir}/xfwm4"

  if [[ "${color}" == '-light' ]] ; then
    cp -r "themerc${color}"                                                           "${xhdpithemedir}/xfwm4/themerc"
  else
    cp -r "themerc${theme}"                                                           "${xhdpithemedir}/xfwm4/themerc"
  fi

  # Install openbox Theme
  mkdir -p                                                                            "${themedir}/openbox-3"
  cd "${SRC_DIR}/openbox-3" || return
  cp -r ./*.xbm                                                                       "${themedir}/openbox-3"
  cp -r "themerc${theme}${ELSE_DARK}"                                                 "${themedir}/openbox-3/themerc"

  # Install labwc Theme
  mkdir -p                                                                            "${themedir}/labwc"
  cd "${SRC_DIR}/labwc" || return
  cp -r assets${theme}${ELSE_LIGHT}/*.png                                             "${themedir}/labwc"
  cp -r "themerc${theme}${ELSE_DARK}${ELSE_LIGHT}"                                    "${themedir}/labwc/themerc"

  # Install Unity Theme
  mkdir -p                                                                            "${themedir}/unity"
  cd "${SRC_DIR}" || return
  cp -r unity                                                                         "${themedir}"

  # Install Plank Theme
  mkdir -p                                                                            "${themedir}/plank"
  cd "${SRC_DIR}/plank/${theme#-}${color}" || return
  cp -r dock.theme                                                                    "${themedir}/plank/"

  # Install GTKSourceView-4 Theme (for gtk+ text editors)
  mkdir -p                                                                            "${DESTDIR}${GTKSV_DIR}/"
  cd "${SRC_DIR}/extra/gtksourceview" || return
  cp -r ./*.xml                                                                       "${DESTDIR}${GTKSV_DIR}/"

  # Fix permissions to ensure all users can read theme files
  # This is especially important when installing to /usr/share/themes with sudo
  if [[ -d "${themedir}" ]]; then
    chmod -R a+r "${themedir}"
    find "${themedir}" -type d -exec chmod a+x {} \;
  fi

  if [[ -d "${hdpithemedir}" ]]; then
    chmod -R a+r "${hdpithemedir}"
    find "${hdpithemedir}" -type d -exec chmod a+x {} \;
  fi

  if [[ -d "${xhdpithemedir}" ]]; then
    chmod -R a+r "${xhdpithemedir}"
    find "${xhdpithemedir}" -type d -exec chmod a+x {} \;
  fi
}

# Backup and install files related to GDM theme
GS_THEME_FILE="/usr/share/gnome-shell/gnome-shell-theme.gresource"
SHELL_THEME_FOLDER="/usr/share/gnome-shell/theme"
ETC_THEME_FOLDER="/etc/alternatives"
ETC_THEME_FILE="/etc/alternatives/gdm3.css"
# ETC_NEW_THEME_FILE is currently unused but kept for potential future use
# shellcheck disable=SC2034
ETC_NEW_THEME_FILE="/etc/alternatives/gdm3-theme.gresource"
UBUNTU_THEME_FILE="/usr/share/gnome-shell/theme/ubuntu.css"
UBUNTU_NEW_THEME_FILE="/usr/share/gnome-shell/theme/gnome-shell.css"
UBUNTU_YARU_THEME_FILE="/usr/share/gnome-shell/theme/Yaru/gnome-shell-theme.gresource"

install_gdm() {
  local dest="${1}"
  local name="${2}"
  local theme="${3}"
  local gcolor="${4}"

  # Skip GDM installation when DESTDIR is set (packaging mode)
  # GDM theme installation modifies system files and should not be done during packaging
  if [[ -n "${DESTDIR}" ]]; then
    echo -e "\nSkipping GDM theme installation (DESTDIR is set for packaging)"
    return
  fi

  # Capitalize theme and color for display names (must match install)
  local theme_cap=""
  local color_cap=""

  if [[ -n "${theme}" ]]; then
    theme_cap="-$(echo "${theme#-}" | sed 's/.*/\u&/')"
  fi

  if [[ -n "${gcolor}" ]]; then
    color_cap="-$(echo "${gcolor#-}" | sed 's/.*/\u&/')"
  fi

  local GDM_THEME_DIR="${dest}/${name}${theme_cap}${color_cap}"
  local YARU_GDM_THEME_DIR="$SHELL_THEME_FOLDER/Yaru/${name}${theme_cap}${color_cap}"

  [[ "${gcolor}" == '-dark' ]] && local ELSE_DARK="${gcolor}"
  # ELSE_LIGHT is set but not currently used in GDM theme files
  # shellcheck disable=SC2034
  [[ "${gcolor}" == '-light' ]] && local ELSE_LIGHT="${gcolor}"

  echo
  echo "Installing ${name}${theme_cap}${color_cap} gdm theme..."

  if ! command -v glib-compile-resources >/dev/null ; then
    echo "glib-compile-resources not found! Exit."
    exit 1
  fi

  if [[ -f "$GS_THEME_FILE" ]] ; then
    echo "Installing '$GS_THEME_FILE'..."
    cp -an "$GS_THEME_FILE" "$GS_THEME_FILE.bak"
    glib-compile-resources \
      --sourcedir="$GDM_THEME_DIR/gnome-shell" \
      --target="$GS_THEME_FILE" \
      "${SRC_DIR}/gnome-shell/gnome-shell-theme.gresource.xml"
  fi

  if [[ -f "$UBUNTU_THEME_FILE" && -f "$GS_THEME_FILE.bak" ]]; then
    echo "Installing '$UBUNTU_THEME_FILE'..."
    cp -an "$UBUNTU_THEME_FILE" "$UBUNTU_THEME_FILE.bak"
    cp -af "$GDM_THEME_DIR/gnome-shell/gnome-shell.css" "$UBUNTU_THEME_FILE"
  fi

  if [[ -f "$UBUNTU_NEW_THEME_FILE" && -f "$GS_THEME_FILE.bak" ]]; then
    echo "Installing '$UBUNTU_NEW_THEME_FILE'..."
    cp -an "$UBUNTU_NEW_THEME_FILE" "$UBUNTU_NEW_THEME_FILE.bak"
    cp -af "$GDM_THEME_DIR"/gnome-shell/* "$SHELL_THEME_FOLDER"
  fi

  # > Ubuntu 18.04
  if [[ -f "$ETC_THEME_FILE" && -f "$GS_THEME_FILE.bak" ]]; then
    echo "Installing Ubuntu GDM theme..."
    cp -an "$ETC_THEME_FILE" "$ETC_THEME_FILE.bak"
    [[ -d "${SHELL_THEME_FOLDER:?}/$THEME_NAME" ]] && rm -rf "${SHELL_THEME_FOLDER:?}/$THEME_NAME"
    cp -r "$GDM_THEME_DIR/gnome-shell" "$SHELL_THEME_FOLDER/$THEME_NAME"
    cd "$ETC_THEME_FOLDER" || return
    [[ -f "$ETC_THEME_FILE.bak" ]] && ln -sf "$SHELL_THEME_FOLDER/$THEME_NAME/gnome-shell.css" gdm3.css
  fi

  # > Ubuntu 20.04
  if [[ -d "$SHELL_THEME_FOLDER/Yaru" && -f "$GS_THEME_FILE.bak" ]]; then
    echo "Installing Ubuntu GDM theme..."
    cp -an "$UBUNTU_YARU_THEME_FILE" "$UBUNTU_YARU_THEME_FILE.bak"
    rm -rf "$UBUNTU_YARU_THEME_FILE"
    rm -rf "$YARU_GDM_THEME_DIR" && mkdir -p "$YARU_GDM_THEME_DIR"

    mkdir -p                                                                           "$YARU_GDM_THEME_DIR"/gnome-shell
    mkdir -p                                                                           "$YARU_GDM_THEME_DIR"/gnome-shell/Yaru
    cp -r "$SRC_DIR"/gnome-shell/{icons,pad-osd.css}                                   "$YARU_GDM_THEME_DIR"/gnome-shell
    cp -r "$SRC_DIR/gnome-shell/${SHELL_VERSION}/gnome-shell${theme}${ELSE_DARK}.css"  "$YARU_GDM_THEME_DIR/gnome-shell/gdm3.css"
    cp -r "$SRC_DIR/gnome-shell/${SHELL_VERSION}/gnome-shell${theme}${ELSE_DARK}.css"  "$YARU_GDM_THEME_DIR/gnome-shell/Yaru/gnome-shell.css"
    cp -r "$SRC_DIR"/gnome-shell/common-assets                                         "$YARU_GDM_THEME_DIR"/gnome-shell/assets
    cp -r "$SRC_DIR"/gnome-shell/assets"${ELSE_DARK}"/calendar-arrow-left.svg          "$YARU_GDM_THEME_DIR"/gnome-shell/assets/calendar-arrow-left.svg
    cp -r "$SRC_DIR"/gnome-shell/assets"${ELSE_DARK}"/calendar-arrow-right.svg         "$YARU_GDM_THEME_DIR"/gnome-shell/assets/calendar-arrow-right.svg
    cp -r "$SRC_DIR"/gnome-shell/assets"${ELSE_DARK}"/checkbox-off.svg                 "$YARU_GDM_THEME_DIR"/gnome-shell/assets/checkbox-off.svg
    cp -r "$SRC_DIR"/gnome-shell/assets"${ELSE_DARK}"/calendar-today.svg               "$YARU_GDM_THEME_DIR"/gnome-shell/assets/calendar-today.svg
    cp -r "$SRC_DIR/gnome-shell/theme-assets/checkbox${theme}.svg"                     "$YARU_GDM_THEME_DIR/gnome-shell/assets/checkbox.svg"
    cp -r "$SRC_DIR/gnome-shell/theme-assets/more-results${theme}.svg"                 "$YARU_GDM_THEME_DIR/gnome-shell/assets/more-results.svg"
    cp -r "$SRC_DIR/gnome-shell/theme-assets/toggle-on${theme}${ELSE_DARK}.svg"        "$YARU_GDM_THEME_DIR/gnome-shell/assets/toggle-on.svg"

    cd "$YARU_GDM_THEME_DIR"/gnome-shell || return
    mv -f assets/no-events.svg no-events.svg
    mv -f assets/process-working.svg process-working.svg
    mv -f assets/no-notifications.svg no-notifications.svg

    glib-compile-resources \
      --sourcedir="$YARU_GDM_THEME_DIR"/gnome-shell \
      --target="$UBUNTU_YARU_THEME_FILE" \
      "$SRC_DIR"/gnome-shell/gdm-theme.gresource.xml

    rm -rf "$YARU_GDM_THEME_DIR"
  fi
}

revert_gdm() {
  if [[ -f "$GS_THEME_FILE.bak" ]]; then
    echo "Reverting '$GS_THEME_FILE'..."
    rm -rf "$GS_THEME_FILE"
    mv "$GS_THEME_FILE.bak" "$GS_THEME_FILE"
  fi

  if [[ -f "$UBUNTU_THEME_FILE.bak" ]]; then
    echo "Reverting '$UBUNTU_THEME_FILE'..."
    rm -rf "$UBUNTU_THEME_FILE"
    mv "$UBUNTU_THEME_FILE.bak" "$UBUNTU_THEME_FILE"
  fi

  if [[ -f "$UBUNTU_NEW_THEME_FILE.bak" ]]; then
    echo "Reverting '$UBUNTU_NEW_THEME_FILE'..."
    rm -rf "$UBUNTU_NEW_THEME_FILE" "$SHELL_THEME_FOLDER"/{assets,no-events.svg,process-working.svg,no-notifications.svg}
    mv "$UBUNTU_NEW_THEME_FILE.bak" "$UBUNTU_NEW_THEME_FILE"
  fi

  # > Ubuntu 18.04
  if [[ -f "$ETC_THEME_FILE.bak" ]]; then

    echo "reverting Ubuntu GDM theme..."

    rm -rf "$ETC_THEME_FILE"
    mv "$ETC_THEME_FILE.bak" "$ETC_THEME_FILE"
    [[ -d "${SHELL_THEME_FOLDER:?}/$THEME_NAME" ]] && rm -rf "${SHELL_THEME_FOLDER:?}/$THEME_NAME"
  fi

  # > Ubuntu 20.04
  if [[ -f "$UBUNTU_YARU_THEME_FILE.bak" ]]; then
    echo "reverting Ubuntu GDM theme..."
    rm -rf "$UBUNTU_YARU_THEME_FILE"
    mv "$UBUNTU_YARU_THEME_FILE.bak" "$UBUNTU_YARU_THEME_FILE"
  fi
}

while [[ $# -gt 0 ]]; do
  case "${1}" in
    -d|--dest)
      dest="${2}"
      shift 2
      ;;
    -n|--name)
      name="${2}"
      shift 2
      ;;
    -g|--gdm)
      gdm='true'
      shift 1
      ;;
    -l|--libadwaita)
      libadwaita='true'
      shift
      ;;
    -k|--kvantum)
      kvantum='true'
      shift
      ;;
    -b|--backgrounds)
      backgrounds='true'
      shift
      ;;
    --copyq)
      copyq='true'
      shift
      ;;
    --cursors)
      cursors='true'
      shift
      ;;
    --ghostty)
      ghostty='true'
      shift
      ;;
    --halloy)
      halloy='true'
      shift
      ;;
    --kde)
      kde='true'
      shift
      ;;
    --kitty)
      kitty='true'
      shift
      ;;
    --zed)
      zed='true'
      shift
      ;;
    -r|--remove|-u|--uninstall)
      remove='true'
      shift
      ;;
    -s|--gnome-shell)
      case "${2}" in
        38)
          SHELL_VERSION=38
          shift 2
          ;;
        40)
          SHELL_VERSION=40
          shift 2
          ;;
        42)
          SHELL_VERSION=42
          shift 2
          ;;
        44)
          SHELL_VERSION=44
          shift 2
          ;;
        46)
          SHELL_VERSION=46
          shift 2
          ;;
        47)
          SHELL_VERSION=47
          shift 2
          ;;
        48)
          SHELL_VERSION=48
          shift 2
          ;;
        -*)
          break
          ;;
        *)
          echo "ERROR: Unrecognized gnome-shell version '$1'."
          echo "Try '$0 --help' for more information."
          exit 1
          ;;
      esac
      ;;
    -t|--theme)
      shift
      for theme in "${@}"; do
        case "${theme}" in
          sea)
            themes+=("${THEME_VARIANTS[0]}")
            shift 1
            ;;
          aliz)
            themes+=("${THEME_VARIANTS[1]}")
            shift 1
            ;;
          azul)
            themes+=("${THEME_VARIANTS[2]}")
            shift 1
            ;;
          pueril)
            themes+=("${THEME_VARIANTS[3]}")
            shift 1
            ;;
          -*)
            break
            ;;
          *)
            echo "ERROR: Unrecognized theme variant '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -c|--color)
      shift
      for color in "${@}"; do
        case "${color}" in
          standard)
            colors+=("${COLOR_VARIANTS[0]}")
            lcolors+=("${COLOR_VARIANTS[0]}")
            gcolors+=("${COLOR_VARIANTS[0]}")
            shift
            ;;
          light)
            colors+=("${COLOR_VARIANTS[1]}")
            lcolors+=("${COLOR_VARIANTS[1]}")
            gcolors+=("${COLOR_VARIANTS[1]}")
            shift
            ;;
          dark)
            colors+=("${COLOR_VARIANTS[2]}")
            lcolors+=("${COLOR_VARIANTS[2]}")
            gcolors+=("${COLOR_VARIANTS[2]}")
            shift
            ;;
          -*)
            break
            ;;
          *)
            echo "ERROR: Unrecognized color variant '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: Unrecognized installation option '$1'."
      echo "Try '$0 --help' for more information."
      exit 1
      ;;
  esac
done

if [[ -z "$SHELL_VERSION" ]]; then
  if [[ "$(command -v gnome-shell)" ]]; then
    gnome-shell --version

    SHELL_VERSION="$(gnome-shell --version | cut -d ' ' -f 3 | cut -d . -f -1)"

    if [[ "${SHELL_VERSION:-}" -ge "48" ]]; then
      SHELL_VERSION="48"
    elif [[ "${SHELL_VERSION:-}" -ge "47" ]]; then
      SHELL_VERSION="47"
    elif [[ "${SHELL_VERSION:-}" -ge "46" ]]; then
      SHELL_VERSION="46"
    elif [[ "${SHELL_VERSION:-}" -ge "44" ]]; then
      SHELL_VERSION="44"
    elif [[ "${SHELL_VERSION:-}" -ge "42" ]]; then
      SHELL_VERSION="42"
    elif [[ "${SHELL_VERSION:-}" -ge "40" ]]; then
      SHELL_VERSION="40"
    else
      SHELL_VERSION="38"
    fi
  else
    echo "'gnome-shell' not found, using styles for last gnome-shell version available."
    SHELL_VERSION="48"
  fi
fi

uninstall() {
  local dest="${1}"
  local name="${2}"
  local theme="${3}"
  local color="${4}"

  # Capitalize theme and color for display names (must match install)
  local theme_cap=""
  local color_cap=""

  if [[ -n "${theme}" ]]; then
    theme_cap="-$(echo "${theme#-}" | sed 's/.*/\u&/')"
  fi

  if [[ -n "${color}" ]]; then
    color_cap="-$(echo "${color#-}" | sed 's/.*/\u&/')"
  fi

  local THEME_DIR="${DESTDIR}${dest}/${name}${theme_cap}${color_cap}"
  local HDPI_THEME_DIR="${DESTDIR}${dest}/${name}${theme_cap}${color_cap}-hdpi"
  local XHDPI_THEME_DIR="${DESTDIR}${dest}/${name}${theme_cap}${color_cap}-xhdpi"

  [[ -d "$THEME_DIR" ]] && rm -rf "$THEME_DIR" && echo -e "Uninstalling $THEME_DIR ..."
  [[ -d "$HDPI_THEME_DIR" ]] && rm -rf "$HDPI_THEME_DIR" && echo -e "Uninstalling $HDPI_THEME_DIR ..."
  [[ -d "$XHDPI_THEME_DIR" ]] && rm -rf "$XHDPI_THEME_DIR" && echo -e "Uninstalling $XHDPI_THEME_DIR ..."

  # Remove GTKSourceView files (only Celestial theme files)
  echo -e "Removing GTKSourceView theme files..."
  rm -f "${DESTDIR}${GTKSV_DIR}/celestial.xml"
}

install_kvantum() {
  local name="${1}"
  local theme="${2}"
  local color="${3}"

  # Capitalize theme and color for display names
  local theme_cap=""
  local color_cap=""

  if [[ -n "${theme}" ]]; then
    theme_cap="-$(echo "${theme#-}" | sed 's/.*/\u&/')"
  fi

  if [[ -n "${color}" ]]; then
    color_cap="-$(echo "${color#-}" | sed 's/.*/\u&/')"
  fi

  local kvantum_name="${name}${theme_cap}${color_cap}"
  local kvantum_src="${SRC_DIR}/Kvantum/${kvantum_name}"
  local kvantum_dest="${DESTDIR}${KVANTUM_DIR}/${kvantum_name}"

  # Check if source Kvantum theme exists
  if [[ ! -d "${kvantum_src}" ]]; then
    echo "Warning: Kvantum theme '${kvantum_name}' not found in source directory, skipping..."
    return
  fi

  echo "Installing Kvantum theme '${kvantum_name}'..."
  mkdir -p "${DESTDIR}${KVANTUM_DIR}"
  [[ -d "${kvantum_dest}" ]] && rm -rf "${kvantum_dest}"
  cp -r "${kvantum_src}" "${kvantum_dest}"
}

uninstall_kvantum() {
  local name="${1}"
  local theme="${2}"
  local color="${3}"

  # Capitalize theme and color for display names
  local theme_cap=""
  local color_cap=""

  if [[ -n "${theme}" ]]; then
    theme_cap="-$(echo "${theme#-}" | sed 's/.*/\u&/')"
  fi

  if [[ -n "${color}" ]]; then
    color_cap="-$(echo "${color#-}" | sed 's/.*/\u&/')"
  fi

  local kvantum_name="${name}${theme_cap}${color_cap}"
  local kvantum_dest="${DESTDIR}${KVANTUM_DIR}/${kvantum_name}"

  if [[ -d "${kvantum_dest}" ]]; then
    echo "Uninstalling Kvantum theme '${kvantum_name}'..."
    rm -rf "${kvantum_dest}"
  fi
}

install_kvantum_themes() {
  local color_list=("${colors[@]}")
  local theme_list=("${themes[@]}")

  [[ ${#color_list[@]} -eq 0 ]] && color_list=("${COLOR_VARIANTS[@]}")
  [[ ${#theme_list[@]} -eq 0 ]] && theme_list=("${THEME_VARIANTS[@]}")

  for color in "${color_list[@]}"; do
    for theme in "${theme_list[@]}"; do
      install_kvantum "${name:-${THEME_NAME}}" "${theme}" "${color}"
    done
  done
}

uninstall_kvantum_themes() {
  local color_list=("${colors[@]}")
  local theme_list=("${themes[@]}")

  [[ ${#color_list[@]} -eq 0 ]] && color_list=("${COLOR_VARIANTS[@]}")
  [[ ${#theme_list[@]} -eq 0 ]] && theme_list=("${THEME_VARIANTS[@]}")

  for color in "${color_list[@]}"; do
    for theme in "${theme_list[@]}"; do
      uninstall_kvantum "${name:-${THEME_NAME}}" "${theme}" "${color}"
    done
  done
}

install_kde_variant() {
  local name="${1}"
  local theme="${2}"
  local color="${3}"

  # Capitalize theme and color to match the color scheme / global theme names
  local theme_cap=""
  local color_cap=""

  if [[ -n "${theme}" ]]; then
    theme_cap="-$(echo "${theme#-}" | sed 's/.*/\u&/')"
  fi

  if [[ -n "${color}" ]]; then
    color_cap="-$(echo "${color#-}" | sed 's/.*/\u&/')"
  fi

  local variant="${name}${theme_cap}${color_cap}"

  # Color scheme
  local cs_src="${SRC_DIR}/kde/color-schemes/${variant}.colors"
  if [[ -f "${cs_src}" ]]; then
    cp "${cs_src}" "${DESTDIR}${COLOR_SCHEMES_DIR}/"
    echo "  Installed color scheme ${variant}.colors"
  else
    echo "Warning: color scheme '${variant}.colors' not found, skipping..."
  fi

  # Look-and-Feel (global theme) package; folder name must equal the KPlugin Id
  local lnf_id="com.github.zquestz.${variant}"
  local lnf_src="${SRC_DIR}/kde/look-and-feel/${lnf_id}"
  if [[ -d "${lnf_src}" ]]; then
    local lnf_dest="${DESTDIR}${PLASMA_LNF_DIR}/${lnf_id}"
    [[ -d "${lnf_dest}" ]] && rm -rf "${lnf_dest}"
    cp -r "${lnf_src}" "${lnf_dest}"
    echo "  Installed global theme ${lnf_id}"
  else
    echo "Warning: global theme '${lnf_id}' not found, skipping..."
  fi

  # Window decoration (Aurorae package)
  local aur_src="${SRC_DIR}/kde/aurorae/${variant}"
  if [[ -d "${aur_src}" ]]; then
    local aur_dest="${DESTDIR}${AURORAE_DIR}/${variant}"
    [[ -d "${aur_dest}" ]] && rm -rf "${aur_dest}"
    cp -r "${aur_src}" "${aur_dest}"
    echo "  Installed window decoration ${variant}"
  else
    echo "Warning: window decoration '${variant}' not found, skipping..."
  fi

  # Plasma desktop theme (panel, popups, tooltip)
  local dt_src="${SRC_DIR}/kde/desktoptheme/${variant}"
  if [[ -d "${dt_src}" ]]; then
    local dt_dest="${DESTDIR}${PLASMA_THEME_DIR}/${variant}"
    [[ -d "${dt_dest}" ]] && rm -rf "${dt_dest}"
    cp -r "${dt_src}" "${dt_dest}"
    echo "  Installed Plasma desktop theme ${variant}"
  else
    echo "Warning: Plasma desktop theme '${variant}' not found, skipping..."
  fi
}

uninstall_kde_variant() {
  local name="${1}"
  local theme="${2}"
  local color="${3}"

  local theme_cap=""
  local color_cap=""

  if [[ -n "${theme}" ]]; then
    theme_cap="-$(echo "${theme#-}" | sed 's/.*/\u&/')"
  fi

  if [[ -n "${color}" ]]; then
    color_cap="-$(echo "${color#-}" | sed 's/.*/\u&/')"
  fi

  local variant="${name}${theme_cap}${color_cap}"

  if [[ -f "${DESTDIR}${COLOR_SCHEMES_DIR}/${variant}.colors" ]]; then
    rm -f "${DESTDIR}${COLOR_SCHEMES_DIR}/${variant}.colors"
    echo "  Removed color scheme ${variant}.colors"
  fi

  local lnf_id="com.github.zquestz.${variant}"
  if [[ -d "${DESTDIR}${PLASMA_LNF_DIR}/${lnf_id}" ]]; then
    rm -rf "${DESTDIR}${PLASMA_LNF_DIR:?}/${lnf_id}"
    echo "  Removed global theme ${lnf_id}"
  fi

  if [[ -d "${DESTDIR}${AURORAE_DIR}/${variant}" ]]; then
    rm -rf "${DESTDIR}${AURORAE_DIR:?}/${variant}"
    echo "  Removed window decoration ${variant}"
  fi

  if [[ -d "${DESTDIR}${PLASMA_THEME_DIR}/${variant}" ]]; then
    rm -rf "${DESTDIR}${PLASMA_THEME_DIR:?}/${variant}"
    echo "  Removed Plasma desktop theme ${variant}"
  fi
}

install_konsole() {
  echo "Installing Konsole terminal scheme..."

  mkdir -p "${DESTDIR}${KONSOLE_DIR}"
  cp "${SRC_DIR}/extra/konsole/Celestial.colorscheme" "${DESTDIR}${KONSOLE_DIR}/"
  echo "Konsole scheme installed to ${DESTDIR}${KONSOLE_DIR}/Celestial.colorscheme"
}

uninstall_konsole() {
  echo "Removing Konsole terminal scheme..."

  if [[ -f "${DESTDIR}${KONSOLE_DIR}/Celestial.colorscheme" ]]; then
    rm -f "${DESTDIR}${KONSOLE_DIR}/Celestial.colorscheme"
    echo "Removed ${DESTDIR}${KONSOLE_DIR}/Celestial.colorscheme"
  fi
}

install_kde() {
  local color_list=("${colors[@]}")
  local theme_list=("${themes[@]}")

  [[ ${#color_list[@]} -eq 0 ]] && color_list=("${COLOR_VARIANTS[@]}")
  [[ ${#theme_list[@]} -eq 0 ]] && theme_list=("${THEME_VARIANTS[@]}")

  echo "Installing KDE Plasma themes..."

  mkdir -p "${DESTDIR}${COLOR_SCHEMES_DIR}"
  mkdir -p "${DESTDIR}${PLASMA_LNF_DIR}"
  mkdir -p "${DESTDIR}${PLASMA_THEME_DIR}"
  mkdir -p "${DESTDIR}${AURORAE_DIR}"

  for color in "${color_list[@]}"; do
    for theme in "${theme_list[@]}"; do
      install_kde_variant "${name:-${THEME_NAME}}" "${theme}" "${color}"
      # A global theme references the Kvantum widget style, so ship it too
      install_kvantum "${name:-${THEME_NAME}}" "${theme}" "${color}"
    done
  done

  install_konsole

  echo "KDE Plasma themes installed."
  echo "See INSTALL.md for the post-install steps."
}

uninstall_kde() {
  local color_list=("${colors[@]}")
  local theme_list=("${themes[@]}")

  [[ ${#color_list[@]} -eq 0 ]] && color_list=("${COLOR_VARIANTS[@]}")
  [[ ${#theme_list[@]} -eq 0 ]] && theme_list=("${THEME_VARIANTS[@]}")

  echo "Removing KDE Plasma themes..."

  for color in "${color_list[@]}"; do
    for theme in "${theme_list[@]}"; do
      uninstall_kde_variant "${name:-${THEME_NAME}}" "${theme}" "${color}"
      uninstall_kvantum "${name:-${THEME_NAME}}" "${theme}" "${color}"
    done
  done

  uninstall_konsole

  echo "KDE Plasma themes uninstalled."
}

generate_theme_xml() {
  local theme_name="${1}"
  local bg_dir="${2}"
  local props_dir="${3}"

  local theme_dir="${bg_dir}/${theme_name}"

  # Check if theme directory exists and has backgrounds
  if [[ ! -d "${theme_dir}" ]] || [[ -z "$(ls -A "${theme_dir}"/*.webp 2>/dev/null)" ]]; then
    return
  fi

  local xml_file="${props_dir}/celestial-${theme_name}.xml"

  # Set theme-specific colors
  local pcolor="#000000"
  local scolor="#000000"

  case "${theme_name}" in
    sea)
      pcolor="#2eb398"
      scolor="#1b2224"
      ;;
    azul)
      pcolor="#3498db"
      scolor="#1b1d24"
      ;;
    aliz)
      pcolor="#f0544c"
      scolor="#222222"
      ;;
    pueril)
      pcolor="#97bb72"
      scolor="#222222"
      ;;
  esac

  # Create XML header
  cat > "${xml_file}" << 'EOF_HEADER'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
<wallpapers>
EOF_HEADER

  # Add entry for each background file in this theme
  for bg_file in "${theme_dir}"/*.webp; do
    if [[ -f "${bg_file}" ]]; then
      local filename
      filename=$(basename "${bg_file}")
      local bg_name="${filename%.webp}"
      # Replace dashes with spaces for display name
      local display_name="${bg_name//-/ }"

      # Strip DESTDIR from path for XML filename
      local xml_path="${theme_dir#"${DESTDIR}"}"

      cat >> "${xml_file}" << EOF
  <wallpaper deleted="false">
    <name>${display_name}</name>
    <filename>${xml_path}/${filename}</filename>
    <options>zoom</options>
    <shade_type>solid</shade_type>
    <pcolor>${pcolor}</pcolor>
    <scolor>${scolor}</scolor>
  </wallpaper>
EOF
    fi
  done

  echo "</wallpapers>" >> "${xml_file}"
}

# Plasma wallpaper packages name their image file by its real resolution
wallpaper_resolution() {
  case "${1}" in
    Azul-Space)
      echo "2688x1536"
      ;;
    *)
      echo "2912x1632"
      ;;
  esac
}

install_background() {
  local theme="${1}"
  local bg_dest="${2}"

  # Remove leading dash from theme name
  local theme_name="${theme#-}"
  local theme_cap
  theme_cap="$(echo "${theme_name}" | sed 's/.*/\u&/')"

  local bg_src="${SRC_DIR}/extra/backgrounds/${theme_name}"

  if [[ ! -d "${bg_src}" ]]; then
    echo "Warning: Background directory '${bg_src}' not found, skipping..."
    return
  fi

  echo "Installing ${theme_cap} backgrounds to '${DESTDIR}${bg_dest}/${theme_name}'..."

  # Create background directory
  mkdir -p "${DESTDIR}${bg_dest}/${theme_name}"

  # Copy background files
  cp -r "${bg_src}"/*.webp "${DESTDIR}${bg_dest}/${theme_name}/" 2>/dev/null || {
    echo "Warning: No background images found in ${bg_src}"
    return
  }
}

# Plasma wallpaper packages (KDE's wallpaper picker); used when -b is combined with --kde
install_wallpaper_packages() {
  local theme="${1}"

  local theme_name="${theme#-}"
  local bg_src="${SRC_DIR}/extra/backgrounds/${theme_name}"

  if [[ ! -d "${bg_src}" ]]; then
    echo "Warning: Background directory '${bg_src}' not found, skipping..."
    return
  fi

  local bg_file wp_name wp_dir
  for bg_file in "${bg_src}"/*.webp; do
    wp_name="$(basename "${bg_file}" .webp)"
    wp_dir="${DESTDIR}${WALLPAPERS_DIR}/Celestial-${wp_name}"
    [[ -d "${wp_dir}" ]] && rm -rf "${wp_dir}"
    mkdir -p "${wp_dir}/contents/images"
    cp "${bg_file}" "${wp_dir}/contents/images/$(wallpaper_resolution "${wp_name}").webp"
    cat > "${wp_dir}/metadata.json" << EOF
{
    "KPackageStructure": "Wallpaper/Images",
    "KPlugin": {
        "Id": "Celestial-${wp_name}",
        "License": "GPL-3.0-or-later",
        "Name": "Celestial ${wp_name//-/ }"
    }
}
EOF
    echo "  Installed wallpaper package Celestial-${wp_name}"
  done
}

uninstall_wallpaper_packages() {
  local theme="${1}"

  local theme_name="${theme#-}"
  local bg_file wp_name
  for bg_file in "${SRC_DIR}/extra/backgrounds/${theme_name}"/*.webp; do
    wp_name="Celestial-$(basename "${bg_file}" .webp)"
    if [[ -d "${DESTDIR}${WALLPAPERS_DIR}/${wp_name}" ]]; then
      rm -rf "${DESTDIR}${WALLPAPERS_DIR:?}/${wp_name}"
      echo "  Removed wallpaper package ${wp_name}"
    fi
  done
}

install_backgrounds() {
  local theme_list=("${themes[@]}")

  [[ ${#theme_list[@]} -eq 0 ]] && theme_list=("${THEME_VARIANTS[@]}")

  # With --kde, backgrounds install as Plasma wallpaper packages instead
  if [[ "${kde:-}" == 'true' ]]; then
    echo "Installing Celestial wallpapers for KDE Plasma..."
    for theme in "${theme_list[@]}"; do
      install_wallpaper_packages "${theme}"
    done
    echo "Wallpapers installed to ${DESTDIR}${WALLPAPERS_DIR}"
    return
  fi

  echo "Installing Celestial backgrounds..."

  for theme in "${theme_list[@]}"; do
    install_background "${theme}" "${BG_DIR}"
  done

  # Generate per-theme XML files for all desktop environments with installed backgrounds
  for props_dir in "${BG_PROPS_DIRS[@]}"; do
    mkdir -p "${DESTDIR}${props_dir}"
    for theme in "${theme_list[@]}"; do
      local theme_name="${theme#-}"
      generate_theme_xml "${theme_name}" "${DESTDIR}${BG_DIR}" "${DESTDIR}${props_dir}"
      if [[ -f "${DESTDIR}${props_dir}/celestial-${theme_name}.xml" ]]; then
        echo "Generated ${DESTDIR}${props_dir}/celestial-${theme_name}.xml"
      fi
    done
  done

  echo "Backgrounds installed successfully!"
  echo "Location: ${DESTDIR}${BG_DIR}"
  echo "You can now select them from your desktop environment's background settings."
}

uninstall_background() {
  local theme="${1}"
  local bg_dest="${2}"

  # Remove leading dash from theme name
  local theme_name="${theme#-}"
  local theme_cap
  theme_cap="$(echo "${theme_name}" | sed 's/.*/\u&/')"

  echo "Removing ${theme_cap} backgrounds..."

  # Remove background directory
  if [[ -d "${DESTDIR}${bg_dest}/${theme_name}" ]]; then
    rm -rf "${DESTDIR}${bg_dest:?}/${theme_name}"
    echo "  Removed ${DESTDIR}${bg_dest}/${theme_name}"
  fi

}

uninstall_backgrounds() {
  local theme_list=("${themes[@]}")

  [[ ${#theme_list[@]} -eq 0 ]] && theme_list=("${THEME_VARIANTS[@]}")

  # With --kde, remove the Plasma wallpaper packages instead
  if [[ "${kde:-}" == 'true' ]]; then
    echo "Removing Celestial wallpapers for KDE Plasma..."
    for theme in "${theme_list[@]}"; do
      uninstall_wallpaper_packages "${theme}"
    done
    return
  fi

  echo "Uninstalling Celestial backgrounds..."

  for theme in "${theme_list[@]}"; do
    uninstall_background "${theme}" "${BG_DIR}"
  done

  # Remove XML files for uninstalled themes
  for theme in "${theme_list[@]}"; do
    local theme_name="${theme#-}"
    for props_dir in "${BG_PROPS_DIRS[@]}"; do
      if [[ -f "${DESTDIR}${props_dir}/celestial-${theme_name}.xml" ]]; then
        rm -f "${DESTDIR}${props_dir}/celestial-${theme_name}.xml"
        echo "Removed ${DESTDIR}${props_dir}/celestial-${theme_name}.xml"
      fi
    done
  done

  # Remove background directory if empty
  if [[ -d "${DESTDIR}${BG_DIR}" ]] && [[ -z "$(ls -A "${DESTDIR}${BG_DIR}" 2>/dev/null)" ]]; then
    rmdir "${DESTDIR}${BG_DIR}" 2>/dev/null
    echo "Removed empty directory ${DESTDIR}${BG_DIR}"
  fi

  echo "Backgrounds uninstalled successfully!"
}

link_libadwaita() {
  local dest="${1}"
  local name="${2}"
  local theme="${3}"
  local lcolor="${4}"

  # Capitalize theme and color for display names (must match install)
  local theme_cap=""
  local color_cap=""

  if [[ -n "${theme}" ]]; then
    theme_cap="-$(echo "${theme#-}" | sed 's/.*/\u&/')"
  fi

  if [[ -n "${lcolor}" ]]; then
    color_cap="-$(echo "${lcolor#-}" | sed 's/.*/\u&/')"
  fi

  # Skip libadwaita linking when DESTDIR is set (packaging mode)
  if [[ -n "${DESTDIR}" ]]; then
    echo -e "\nSkipping libadwaita linking (DESTDIR is set for packaging)"
    return
  fi

  local THEME_DIR="${dest}/${name}${theme_cap}${color_cap}"

  echo -e "\nLink '$THEME_DIR/gtk-4.0' to '${HOME}/.config/gtk-4.0' for libadwaita..."

  mkdir -p                                                                      "${HOME}/.config/gtk-4.0"
  ln -sf "${THEME_DIR}/gtk-4.0/assets"                                          "${HOME}/.config/gtk-4.0/assets"
  ln -sf "${THEME_DIR}/gtk-4.0/gtk.css"                                         "${HOME}/.config/gtk-4.0/gtk.css"
  ln -sf "${THEME_DIR}/gtk-4.0/gtk-dark.css"                                    "${HOME}/.config/gtk-4.0/gtk-dark.css"
}

uninstall_link() {
  rm -rf "${HOME}/.config/gtk-4.0"/{assets,gtk.css,gtk-dark.css}
}

install_ghostty() {
  echo "Installing Ghostty terminal theme..."

  mkdir -p "${DESTDIR}${GHOSTTY_DIR}"
  cp "${SRC_DIR}/extra/ghostty/Celestial" "${DESTDIR}${GHOSTTY_DIR}/"
  echo "Ghostty theme installed to ${DESTDIR}${GHOSTTY_DIR}/Celestial"
}

uninstall_ghostty() {
  echo "Removing Ghostty terminal theme..."

  if [[ -f "${DESTDIR}${GHOSTTY_DIR}/Celestial" ]]; then
    rm -f "${DESTDIR}${GHOSTTY_DIR}/Celestial"
    echo "Removed ${DESTDIR}${GHOSTTY_DIR}/Celestial"
  else
    echo "Ghostty theme not found at ${DESTDIR}${GHOSTTY_DIR}/Celestial"
  fi
}

install_kitty() {
  echo "Installing Kitty terminal theme..."

  if [[ -z "${KITTY_DIR}" ]]; then
    echo "Kitty theme installation is not available for system-wide installs (root)"
    echo "Kitty themes must be installed per-user"
    return
  fi

  mkdir -p "${DESTDIR}${KITTY_DIR}"
  cp "${SRC_DIR}/extra/kitty/Celestial.conf" "${DESTDIR}${KITTY_DIR}/"
  echo "Kitty theme installed to ${DESTDIR}${KITTY_DIR}/Celestial.conf"
}

uninstall_kitty() {
  echo "Removing Kitty terminal theme..."

  if [[ -z "${KITTY_DIR}" ]]; then
    return
  fi

  if [[ -f "${DESTDIR}${KITTY_DIR}/Celestial.conf" ]]; then
    rm -f "${DESTDIR}${KITTY_DIR}/Celestial.conf"
    echo "Removed ${DESTDIR}${KITTY_DIR}/Celestial.conf"
  else
    echo "Kitty theme not found at ${DESTDIR}${KITTY_DIR}/Celestial.conf"
  fi
}

install_halloy() {
  local theme_list=("${themes[@]}")

  [[ ${#theme_list[@]} -eq 0 ]] && theme_list=("${THEME_VARIANTS[@]}")

  echo "Installing Halloy IRC client themes..."

  if [[ -z "${HALLOY_DIR}" ]]; then
    echo "Halloy theme installation is not available for system-wide installs (root)"
    echo "Halloy themes must be installed per-user"
    return
  fi

  mkdir -p "${DESTDIR}${HALLOY_DIR}"

  for theme in "${theme_list[@]}"; do
    local theme_name="${theme#-}"
    cp "${SRC_DIR}/extra/halloy/celestial-${theme_name}.toml" "${DESTDIR}${HALLOY_DIR}/"
    echo "  Installed celestial-${theme_name}.toml"
  done

  echo "Halloy themes installed to ${DESTDIR}${HALLOY_DIR}/"
  echo "Configure in your Halloy config.toml with: theme = \"celestial-<variant>\""
}

uninstall_halloy() {
  local theme_list=("${themes[@]}")

  [[ ${#theme_list[@]} -eq 0 ]] && theme_list=("${THEME_VARIANTS[@]}")

  echo "Removing Halloy IRC client themes..."

  if [[ -z "${HALLOY_DIR}" ]]; then
    return
  fi

  for theme in "${theme_list[@]}"; do
    local theme_name="${theme#-}"
    if [[ -f "${DESTDIR}${HALLOY_DIR}/celestial-${theme_name}.toml" ]]; then
      rm -f "${DESTDIR}${HALLOY_DIR}/celestial-${theme_name}.toml"
      echo "  Removed celestial-${theme_name}.toml"
    fi
  done

  echo "Halloy themes uninstalled."
}

install_copyq() {
  local theme_list=("${themes[@]}")
  local color_list=("${colors[@]}")

  [[ ${#theme_list[@]} -eq 0 ]] && theme_list=("${THEME_VARIANTS[@]}")
  [[ ${#color_list[@]} -eq 0 ]] && color_list=("${COLOR_VARIANTS[@]}")

  echo "Installing CopyQ clipboard manager themes..."

  mkdir -p "${DESTDIR}${COPYQ_DIR}"

  for theme in "${theme_list[@]}"; do
    local theme_name="${theme#-}"
    for color in "${color_list[@]}"; do
      local color_name="${color#-}"
      if [[ -z "${color_name}" ]]; then
        # Install both light and dark for standard variant
        cp "${SRC_DIR}/extra/copyq/celestial-${theme_name}-light.ini" "${DESTDIR}${COPYQ_DIR}/"
        echo "  Installed celestial-${theme_name}-light.ini"
        cp "${SRC_DIR}/extra/copyq/celestial-${theme_name}-dark.ini" "${DESTDIR}${COPYQ_DIR}/"
        echo "  Installed celestial-${theme_name}-dark.ini"
        break  # Don't process light and dark again after standard
      else
        cp "${SRC_DIR}/extra/copyq/celestial-${theme_name}-${color_name}.ini" "${DESTDIR}${COPYQ_DIR}/"
        echo "  Installed celestial-${theme_name}-${color_name}.ini"
      fi
    done
  done

  echo "CopyQ themes installed to ${DESTDIR}${COPYQ_DIR}/"
}

uninstall_copyq() {
  local theme_list=("${themes[@]}")
  local color_list=("${colors[@]}")

  [[ ${#theme_list[@]} -eq 0 ]] && theme_list=("${THEME_VARIANTS[@]}")
  [[ ${#color_list[@]} -eq 0 ]] && color_list=("${COLOR_VARIANTS[@]}")

  echo "Removing CopyQ clipboard manager themes..."

  for theme in "${theme_list[@]}"; do
    local theme_name="${theme#-}"
    for color in "${color_list[@]}"; do
      local color_name="${color#-}"
      if [[ -z "${color_name}" ]]; then
        # Remove both light and dark for standard variant
        if [[ -f "${DESTDIR}${COPYQ_DIR}/celestial-${theme_name}-light.ini" ]]; then
          rm -f "${DESTDIR}${COPYQ_DIR}/celestial-${theme_name}-light.ini"
          echo "  Removed celestial-${theme_name}-light.ini"
        fi
        if [[ -f "${DESTDIR}${COPYQ_DIR}/celestial-${theme_name}-dark.ini" ]]; then
          rm -f "${DESTDIR}${COPYQ_DIR}/celestial-${theme_name}-dark.ini"
          echo "  Removed celestial-${theme_name}-dark.ini"
        fi
        break  # Don't process light and dark again after standard
      else
        if [[ -f "${DESTDIR}${COPYQ_DIR}/celestial-${theme_name}-${color_name}.ini" ]]; then
          rm -f "${DESTDIR}${COPYQ_DIR}/celestial-${theme_name}-${color_name}.ini"
          echo "  Removed celestial-${theme_name}-${color_name}.ini"
        fi
      fi
    done
  done
}

install_zed() {
  local theme_list=("${themes[@]}")

  [[ ${#theme_list[@]} -eq 0 ]] && theme_list=("${THEME_VARIANTS[@]}")

  echo "Installing Zed editor themes..."

  if [[ -z "${ZED_DIR}" ]]; then
    echo "Zed theme installation is not available for system-wide installs (root)"
    echo "Zed themes must be installed per-user"
    return
  fi

  mkdir -p "${DESTDIR}${ZED_DIR}"

  for theme in "${theme_list[@]}"; do
    local theme_name="${theme#-}"
    cp "${SRC_DIR}/extra/zed/celestial-${theme_name}.json" "${DESTDIR}${ZED_DIR}/"
    echo "  Installed celestial-${theme_name}.json"
  done

  echo "Zed themes installed to ${DESTDIR}${ZED_DIR}/"
}

uninstall_zed() {
  local theme_list=("${themes[@]}")

  [[ ${#theme_list[@]} -eq 0 ]] && theme_list=("${THEME_VARIANTS[@]}")

  echo "Removing Zed editor themes..."

  if [[ -z "${ZED_DIR}" ]]; then
    return
  fi

  for theme in "${theme_list[@]}"; do
    local theme_name="${theme#-}"
    if [[ -f "${DESTDIR}${ZED_DIR}/celestial-${theme_name}.json" ]]; then
      rm -f "${DESTDIR}${ZED_DIR}/celestial-${theme_name}.json"
      echo "  Removed celestial-${theme_name}.json"
    fi
  done
}

link_theme() {
  local lcolor_list=("${lcolors[@]}")
  local theme_list=("${themes[@]}")

  [[ ${#lcolor_list[@]} -eq 0 ]] && lcolor_list=("${COLOR_VARIANTS[2]}")
  [[ ${#theme_list[@]} -eq 0 ]] && theme_list=("${THEME_VARIANTS[0]}")

  for lcolor in "${lcolor_list[@]}"; do
    for theme in "${theme_list[@]}"; do
      link_libadwaita "${dest:-$DEST_DIR}" "${name:-$THEME_NAME}" "${theme}" "${lcolor}"
    done
  done
}

install_cursors() {
  echo "Installing Celestial cursor theme..."

  local cursor_dest="${DESTDIR}${CURSORS_DIR}/Celestial"
  local cursor_src="${SRC_DIR}/cursors/dist"

  # Remove old installation if it exists
  if [[ -d "${cursor_dest}" ]]; then
    rm -rf "${cursor_dest}"
  fi

  # Create destination directory
  mkdir -p "${cursor_dest}"

  # Copy cursor files
  cp -r "${cursor_src}"/* "${cursor_dest}/"

  echo "Celestial cursor theme installed to ${cursor_dest}"
}

uninstall_cursors() {
  echo "Removing Celestial cursor theme..."

  local cursor_dest="${DESTDIR}${CURSORS_DIR}/Celestial"

  if [[ -d "${cursor_dest}" ]]; then
    rm -rf "${cursor_dest}"
    echo "Celestial cursor theme removed."
  else
    echo "Celestial cursor theme is not installed."
  fi
}

install_theme() {
  local color_list=("${colors[@]}")
  local theme_list=("${themes[@]}")

  [[ ${#color_list[@]} -eq 0 ]] && color_list=("${COLOR_VARIANTS[@]}")
  [[ ${#theme_list[@]} -eq 0 ]] && theme_list=("${THEME_VARIANTS[@]}")

  for color in "${color_list[@]}"; do
    for theme in "${theme_list[@]}"; do
      install "${dest:-${DEST_DIR}}" "${name:-${THEME_NAME}}" "${theme}" "${color}"
    done
  done
}

uninstall_theme() {
  local color_list=("${colors[@]}")
  local theme_list=("${themes[@]}")

  [[ ${#color_list[@]} -eq 0 ]] && color_list=("${COLOR_VARIANTS[@]}")
  [[ ${#theme_list[@]} -eq 0 ]] && theme_list=("${THEME_VARIANTS[@]}")

  for color in "${color_list[@]}"; do
    for theme in "${theme_list[@]}"; do
      uninstall "${dest:-$DEST_DIR}" "${name:-$THEME_NAME}" "${theme}" "${color}"
    done
  done
}

if [[ "${gdm:-}" != 'true' ]]; then
  if [[ "${remove:-}" != 'true' ]]; then
    install_theme

    if [[ "${libadwaita:-}" == 'true' ]]; then
      uninstall_link && link_theme
    fi

    # --kde already installs the Kvantum themes, so skip the duplicate pass
    if [[ "${kvantum:-}" == 'true' && "${kde:-}" != 'true' ]]; then
      install_kvantum_themes
    fi

    if [[ "${backgrounds:-}" == 'true' ]]; then
      install_backgrounds
    fi

    if [[ "${copyq:-}" == 'true' ]]; then
      install_copyq
    fi

    if [[ "${cursors:-}" == 'true' ]]; then
      install_cursors
    fi

    if [[ "${ghostty:-}" == 'true' ]]; then
      install_ghostty
    fi

    if [[ "${halloy:-}" == 'true' ]]; then
      install_halloy
    fi

    if [[ "${kde:-}" == 'true' ]]; then
      install_kde
    fi

    if [[ "${kitty:-}" == 'true' ]]; then
      install_kitty
    fi

    if [[ "${zed:-}" == 'true' ]]; then
      install_zed
    fi
  else
    if [[ "${libadwaita:-}" == 'true' ]]; then
      uninstall_link
      echo -e 'Remove libadwaita links...'
    elif [[ "${kvantum:-}" == 'true' ]]; then
      uninstall_kvantum_themes
      echo -e 'Remove Kvantum themes...'
    elif [[ "${backgrounds:-}" == 'true' ]]; then
      uninstall_backgrounds
      echo -e 'Remove backgrounds...'
    elif [[ "${copyq:-}" == 'true' ]]; then
      uninstall_copyq
      echo -e 'Remove CopyQ themes...'
    elif [[ "${cursors:-}" == 'true' ]]; then
      uninstall_cursors
      echo -e 'Remove Celestial cursor theme...'
    elif [[ "${ghostty:-}" == 'true' ]]; then
      uninstall_ghostty
      echo -e 'Remove Ghostty theme...'
    elif [[ "${halloy:-}" == 'true' ]]; then
      uninstall_halloy
      echo -e 'Remove Halloy themes...'
    elif [[ "${kde:-}" == 'true' ]]; then
      uninstall_kde
      echo -e 'Remove KDE Plasma themes...'
    elif [[ "${kitty:-}" == 'true' ]]; then
      uninstall_kitty
      echo -e 'Remove Kitty theme...'
    elif [[ "${zed:-}" == 'true' ]]; then
      uninstall_zed
      echo -e 'Remove Zed theme...'
    else
      uninstall_theme
    fi
  fi
fi

if [[ "${gdm:-}" == 'true' && "${remove:-}" != 'true' && "$UID" -eq "$ROOT_UID" ]]; then
  if [[ "${#gcolors[@]}" -gt 1 ]]; then
    echo -e 'Error: To install a gdm theme you can only select one color'
    exit 1
  fi

  if [[ "${#themes[@]}" -gt 1 ]]; then
    echo -e 'Error: To install a gdm theme you can only select one theme'
    exit 1
  fi

  echo -e "\nNOTICE: Only GDM theme will installed..."

  gcolor_list=("${gcolors[@]}")
  theme_list=("${themes[@]}")

  [[ ${#gcolor_list[@]} -eq 0 ]] && gcolor_list=("${COLOR_VARIANTS[2]}")
  [[ ${#theme_list[@]} -eq 0 ]] && theme_list=("${THEME_VARIANTS[0]}")

  for gcolor in "${gcolor_list[@]}"; do
    for theme in "${theme_list[@]}"; do
      install_gdm "${dest:-${DEST_DIR}}" "${name:-${THEME_NAME}}" "${theme}" "${gcolor}"
    done
  done
fi

if [[ "${gdm:-}" == 'true' && "${remove:-}" == 'true' && "$UID" -eq "$ROOT_UID" ]]; then
  revert_gdm
fi

echo "Finished!..."
