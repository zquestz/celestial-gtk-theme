#! /usr/bin/env bash
# shellcheck disable=SC2086

# Change to script directory so it works from any location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

INKSCAPE="/usr/bin/inkscape"
OPTIPNG="/usr/bin/optipng"

INDEX="assets.txt"

for variant in '' '-dark'; do
  for color in '-sea' '-aliz' '-azul' '-pueril'; do

    ASSETS_DIR="assets${color}${variant}"
    SRC_FILE="assets${color}${variant}.svg"

    install -d "$ASSETS_DIR"

    while IFS= read -r i; do
      if [ -f "$ASSETS_DIR/$i.png" ]; then
        echo "$ASSETS_DIR/$i.png exists."
      else
        echo
        echo "Rendering $ASSETS_DIR/$i.png"
        $INKSCAPE --export-id="$i" \
                  --export-id-only \
                  --export-filename="$ASSETS_DIR/$i.png" "$SRC_FILE" >/dev/null \
        && $OPTIPNG -o7 --quiet "$ASSETS_DIR/$i.png"
      fi
    done < "$INDEX"
  done
done

exit 0
