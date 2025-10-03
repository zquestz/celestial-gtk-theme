#!/usr/bin/env bash
# shellcheck disable=SC2086

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

TEMPLATE="dock.theme.template"

# Color definitions: Name R G B Hex
declare -A COLORS=(
    ["sea"]="46 179 152 #2eb398"
    ["aliz"]="240 84 76 #f0544c"
    ["azul"]="52 152 219 #3498db"
    ["pueril"]="151 187 114 #97bb72"
)

declare -A THEME_NAMES=(
    ["sea"]="Sea"
    ["aliz"]="Aliz"
    ["azul"]="Azul"
    ["pueril"]="Pueril"
)

DARK_BG="26;;30;;34"
LIGHT_BG="250;;250;;250"

DARK_OUTER_STROKE="0;;0;;0;;95"
LIGHT_OUTER_STROKE="200;;200;;200;;95"

generate_theme() {
    local theme="$1"
    local variant="$2"
    local output_dir="$3"

    IFS=' ' read -r R G B HEX <<< "${COLORS[$theme]}"

    local theme_name="${THEME_NAMES[$theme]}"
    local variant_name
    case "$variant" in
        "")
            variant_name="Standard/Dark"
            ;;
        "-dark")
            variant_name="Dark"
            ;;
        "-light")
            variant_name="Light"
            ;;
    esac

    local fill_bg outer_stroke inner_stroke
    if [[ "$variant" == "-light" ]]; then
        fill_bg="${LIGHT_BG}"
        outer_stroke="${LIGHT_OUTER_STROKE}"
        inner_stroke="${LIGHT_BG};;245"
    else
        fill_bg="${DARK_BG}"
        outer_stroke="${DARK_OUTER_STROKE}"
        inner_stroke="${DARK_BG};;245"
    fi

    mkdir -p "$output_dir"

    sed -e "s|{{THEME_NAME}}|${theme_name}|g" \
        -e "s|{{VARIANT_NAME}}|${variant_name}|g" \
        -e "s|{{HEX_COLOR}}|${HEX}|g" \
        -e "s|{{RGB_COLOR}}|${R}, ${G}, ${B}|g" \
        -e "s|{{OUTER_STROKE}}|${outer_stroke}|g" \
        -e "s|{{FILL_BG}}|${fill_bg};;215|g" \
        -e "s|{{INNER_STROKE}}|${inner_stroke}|g" \
        -e "s|{{INDICATOR_COLOR}}|${R};;${G};;${B};;255|g" \
        -e "s|{{BADGE_COLOR}}|${R};;${G};;${B};;255|g" \
        -e "s|{{ACTIVE_ITEM_COLOR}}|${R};;${G};;${B};;40|g" \
        "$TEMPLATE" > "$output_dir/dock.theme"

    echo "Rendering $output_dir/dock.theme"
}

for theme in sea aliz azul pueril; do
    generate_theme "$theme" "" "${theme}"
    generate_theme "$theme" "-dark" "${theme}-dark"
    generate_theme "$theme" "-light" "${theme}-light"
done
