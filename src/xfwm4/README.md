# Xfwm4 Window Manager Theme Assets

This directory contains the Xfwm4 (Xfce Window Manager) theme assets and tools to regenerate them.

## Regenerating Assets

If you modify the SVG source files, you can regenerate the PNG assets using the provided script.

### Requirements

- `inkscape` - For rendering SVG to PNG
- `optipng` - For optimizing PNG files

### Usage

```bash
./render-assets.sh
```

This script will:
1. Read asset names from `assets.txt`
2. Extract and render each asset from the corresponding SVG file for each color variant and theme mode
3. Generate standard, HiDPI (@2), and XHiDPI (@3) versions for retina displays
4. Optimize the resulting PNG files

### Files

- `assets-*.svg` - Source SVG files containing all window decoration assets for each color variant and mode
- `assets.txt` - List of asset IDs to extract from the SVG files (window buttons, borders, etc.)
- `assets-*/` - Output directories containing the rendered PNG assets
- `themerc-*` - Xfwm4 theme configuration files for each variant
- `render-assets.sh` - Script to regenerate all assets

## Display Scaling Support

The theme includes full HiDPI support with three resolution variants:

- **Standard** - Normal DPI displays (1x scaling)
- **HiDPI** - High DPI displays (2x scaling)
- **XHiDPI** - Extra high DPI displays (3x scaling)

## Color Variants

The theme includes four color variants, each with light and dark modes:
- **Sea** - Cool cyan tones
- **Aliz** - Warm crimson hues
- **Azul** - Deep blue accents
- **Pueril** - Fresh green tones

## Window Decoration Assets

Assets include all window manager decorations:
- Title bar buttons (close, minimize, maximize, shade)
- Window borders and corners
- Active and inactive states
- Pressed and hover states

## Notes

- Assets are generated per color variant, theme mode (light/dark/standard), and DPI level
- The script only regenerates missing assets by default
- To force regeneration, delete the asset directories before running the script
- Xfwm4 will automatically select the appropriate DPI variant based on your display settings
