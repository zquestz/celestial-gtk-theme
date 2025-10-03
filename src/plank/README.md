# Plank Themes

This directory contains Plank dock themes for all Celestial theme variants.

## Theme Colors

Each theme variant uses its corresponding accent color:

- **Sea**:    #2eb398 RGB(46, 179, 152)   - Cyan/Teal
- **Aliz**:   #f0544c RGB(240, 84, 76)    - Red/Crimson
- **Azul**:   #3498db RGB(52, 152, 219)   - Blue
- **Pueril**: #97bb72 RGB(151, 187, 114)  - Green

The accent colors are applied to:
- Indicator color (active application dot)
- Badge color (notification badge)
- Active item background

Light variants use light backgrounds (RGB 250, 250, 250) while dark variants use dark backgrounds (RGB 26, 30, 34).

## Regenerating Themes

If you modify the template or want to regenerate all themes:

```bash
cd src/plank
./render-plank-themes.sh
```

This will regenerate all 12 Plank theme variants from the template.

## Modifying Themes

### To change all themes at once:

1. Edit `dock.theme.template`
2. Run `./render-plank-themes.sh`

### To change colors:

Edit the color definitions in `render-plank-themes.sh`:

```bash
declare -A COLORS=(
    ["sea"]="46 179 152 #2eb398"
    ["aliz"]="240 84 76 #f0544c"
    ["azul"]="52 152 219 #3498db"
    ["pueril"]="151 187 114 #97bb72"
)
```

### Template Placeholders:

- `{{THEME_NAME}}` - Theme name (Sea, Aliz, Azul, Pueril)
- `{{VARIANT_NAME}}` - Variant name (Standard/Dark, Light, Dark)
- `{{HEX_COLOR}}` - Hex color code
- `{{RGB_COLOR}}` - RGB color as comma-separated values
- `{{OUTER_STROKE}}` - Outer stroke color (RGBA with ;; separators)
- `{{FILL_BG}}` - Fill background color
- `{{INNER_STROKE}}` - Inner stroke color
- `{{INDICATOR_COLOR}}` - Indicator dot color
- `{{BADGE_COLOR}}` - Badge color
- `{{ACTIVE_ITEM_COLOR}}` - Active item background color

## Plank Color Format

Plank uses a unique color format: `R;;G;;B;;A` where values range from 0-255 and components are separated by double semicolons.

Example: `46;;179;;152;;255` represents RGB(46, 179, 152) with full opacity.
