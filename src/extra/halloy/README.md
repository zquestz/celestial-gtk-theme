# Celestial Halloy Themes

Halloy IRC client themes that match the Celestial GTK theme color variants.

## Overview

These themes are designed to provide a cohesive visual experience when using Halloy alongside the Celestial GTK theme. Each theme variant corresponds to one of the four Celestial color schemes.

## Available Themes

- **celestial-sea.toml** - Teal accent (`#2eb398`)
- **celestial-aliz.toml** - Red accent (`#f0544c`)
- **celestial-azul.toml** - Blue accent (`#3498db`)
- **celestial-pueril.toml** - Green accent (`#97bb72`)

All themes use dark backgrounds and are optimized for readability and extended use.

## Installation

### Automatic Installation (Recommended)

The easiest way to install Halloy themes is using the Celestial theme installer:

```bash
# Install all four Halloy theme variants
./install.sh --halloy

# Install specific variants only
./install.sh --halloy -t sea
./install.sh --halloy -t azul -t aliz

# Uninstall
./install.sh -r --halloy
```

The installer will copy theme files to `~/.config/halloy/themes/` for you.

### Manual Installation

1. Locate your Halloy configuration directory:
   - **Linux**: `~/.config/halloy/`
   - **macOS**: `~/Library/Application Support/halloy/`
   - **Windows**: `%APPDATA%\halloy\`

2. Create a `themes` subdirectory if it doesn't exist:

   ```bash
   mkdir -p ~/.config/halloy/themes
   ```

3. Copy your chosen theme file to the themes directory:

   ```bash
   cp celestial-sea.toml ~/.config/halloy/themes/
   ```

4. In your Halloy `config.toml`, reference the theme (without the `.toml` extension):

   ```toml
   theme = "celestial-sea"
   ```

5. Restart Halloy to apply the theme.

**Note:** Halloy themes can only be installed per-user. System-wide (root) installation is not supported.

## Color Palette

Each theme uses the following color philosophy:

- **Primary accent**: Matches the Celestial variant's main accent color
- **Backgrounds**: Uses authentic Celestial dark theme backgrounds
- **Text colors**: Follows Celestial's text hierarchy (primary, secondary, tertiary)
- **Error/Warning**: Consistent across all variants using Celestial system colors
- **Cross-variant accents**: Nicknames, URLs, and code highlighting use complementary colors from other Celestial variants for visual variety

### Common Colors Across All Variants

- **Error**: `#fc4138` (red)
- **Warning**: `#f27835` (orange)
- **Success**: `#97bb72` (green)
- **Info/URLs**: `#3498db` (blue)
- **Code/Debug**: `#c678dd` (purple)
- **Highlight**: `#f7dc6f` (yellow)

## Customization

Feel free to modify these themes to suit your preferences. The color values are clearly commented, making it easy to adjust individual elements while maintaining the overall Celestial aesthetic.

## Resources

- [Halloy IRC Client](https://github.com/squidowl/halloy)
- [Celestial GTK Theme](https://github.com/zquestz/celestial-gtk-theme)
- [Halloy Theme Documentation](https://halloy.chat/configuration/themes/index.html)

## License

These themes are part of the Celestial GTK Theme project and are licensed under the GNU General Public License v3.0.
