#! /usr/bin/env bash
# shellcheck disable=SC2086

if [ ! "$(which sassc 2> /dev/null)" ]; then
   echo sassc needs to be installed to generate the css.
   exit 1
fi

SASSC_OPT="-M -t expanded"

_COLOR_VARIANTS=('' '-light' '-dark')
if [[ -n "${COLOR_VARIANTS:-}" ]]; then
  IFS=', ' read -r -a _COLOR_VARIANTS <<< "${COLOR_VARIANTS:-}"
fi

_ECOLOR_VARIANTS=('' '-dark')
if [[ -n "${ECOLOR_VARIANTS:-}" ]]; then
  IFS=', ' read -r -a _ECOLOR_VARIANTS <<< "${ECOLOR_VARIANTS:-}"
fi

_THEME_VARIANTS=('-sea' '-aliz' '-azul' '-pueril')
if [[ -n "${THEME_VARIANTS:-}" ]]; then
  IFS=', ' read -r -a _THEME_VARIANTS <<< "${THEME_VARIANTS:-}"
fi

for color in "${_COLOR_VARIANTS[@]}"; do
  for theme in "${_THEME_VARIANTS[@]}"; do
    sassc $SASSC_OPT "src/gtk/gtk-3.0/gtk${theme}${color}.scss" "src/gtk/gtk-3.0/gtk${theme}${color}.css"
    echo "==> Generating the GTK 3.0 gtk${theme}${color}.css..."
    sassc $SASSC_OPT "src/gtk/gtk-4.0/gtk${theme}${color}.scss" "src/gtk/gtk-4.0/gtk${theme}${color}.css"
    echo "==> Generating the GTK 4.0 gtk${theme}${color}.css..."
  done
done

for color in "${_ECOLOR_VARIANTS[@]}"; do
  for theme in "${_THEME_VARIANTS[@]}"; do
    sassc $SASSC_OPT "src/gnome-shell/38/gnome-shell${theme}${color}.scss" "src/gnome-shell/38/gnome-shell${theme}${color}.css"
    echo "==> Generating the 38 gnome-shell${theme}${color}.css..."
    sassc $SASSC_OPT "src/gnome-shell/40/gnome-shell${theme}${color}.scss" "src/gnome-shell/40/gnome-shell${theme}${color}.css"
    echo "==> Generating the 40.0 gnome-shell${theme}${color}.css..."
    sassc $SASSC_OPT "src/gnome-shell/42/gnome-shell${theme}${color}.scss" "src/gnome-shell/42/gnome-shell${theme}${color}.css"
    echo "==> Generating the 42.0 gnome-shell${theme}${color}.css..."
    sassc $SASSC_OPT "src/gnome-shell/44/gnome-shell${theme}${color}.scss" "src/gnome-shell/44/gnome-shell${theme}${color}.css"
    echo "==> Generating the 44.0 gnome-shell${theme}${color}.css..."
    sassc $SASSC_OPT "src/gnome-shell/46/gnome-shell${theme}${color}.scss" "src/gnome-shell/46/gnome-shell${theme}${color}.css"
    echo "==> Generating the 46.0 gnome-shell${theme}${color}.css..."
    sassc $SASSC_OPT "src/gnome-shell/47/gnome-shell${theme}${color}.scss" "src/gnome-shell/47/gnome-shell${theme}${color}.css"
    echo "==> Generating the 47.0 gnome-shell${theme}${color}.css..."
    sassc $SASSC_OPT "src/gnome-shell/48/gnome-shell${theme}${color}.scss" "src/gnome-shell/48/gnome-shell${theme}${color}.css"
    echo "==> Generating the 48.0 gnome-shell${theme}${color}.css..."
    sassc $SASSC_OPT "src/gnome-shell/49/gnome-shell${theme}${color}.scss" "src/gnome-shell/49/gnome-shell${theme}${color}.css"
    echo "==> Generating the 49.0 gnome-shell${theme}${color}.css..."
    sassc $SASSC_OPT "src/gnome-shell/50/gnome-shell${theme}${color}.scss" "src/gnome-shell/50/gnome-shell${theme}${color}.css"
    echo "==> Generating the 50.0 gnome-shell${theme}${color}.css..."
  done
done

for color in "${_ECOLOR_VARIANTS[@]}"; do
  for theme in "${_THEME_VARIANTS[@]}"; do
    sassc $SASSC_OPT "src/cinnamon/cinnamon${theme}${color}.scss" "src/cinnamon/cinnamon${theme}${color}.css"
    echo "==> Generating the cinnamon${theme}${color}.css..."
  done
done
