# GTK Theme Assets

This directory contains the GTK theme assets and tools to regenerate them.

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
2. Extract and render each asset from the corresponding SVG file for each color variant (aliz, azul, sea, pueril)
3. Generate both standard and HiDPI (@2) versions
4. Optimize the resulting PNG files

### Files

- `assets-*.svg` - Source SVG files containing all assets for each color variant
- `assets.txt` - List of asset IDs to extract from the SVG files
- `assets-*/` - Output directories containing the rendered PNG assets
- `render-assets.sh` - Script to regenerate all assets

## Notes

- Assets are generated per color variant to maintain theme consistency
- The script only regenerates missing assets by default
- To force regeneration, delete the asset directories before running the script