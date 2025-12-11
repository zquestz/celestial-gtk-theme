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

# Theme-specific dark background colors (matching each variant's bg_color_dark)
declare -A DARK_BGS=(
    ["sea"]="27;;34;;36"       # #1b2224
    ["aliz"]="34;;34;;34"      # #222222
    ["azul"]="27;;29;;36"      # #1b1d24
    ["pueril"]="34;;34;;34"    # #222222
)

# Theme-specific outer stroke colors (darker version of background)
declare -A DARK_OUTER_STROKES=(
    ["sea"]="20;;26;;28;;215"       # darker #1b2224
    ["aliz"]="26;;26;;26;;215"      # darker #222222
    ["azul"]="20;;22;;28;;215"      # darker #1b1d24
    ["pueril"]="26;;26;;26;;215"    # darker #222222
)

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

    # Always use dark background for dock (consistent with panel)
    local dark_bg="${DARK_BGS[$theme]}"
    local fill_bg="${dark_bg}"
    local outer_stroke="${DARK_OUTER_STROKES[$theme]}"
    local inner_stroke="${dark_bg};;245"

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
