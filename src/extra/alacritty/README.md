# Celestial Theme for Alacritty

A dark terminal theme for [Alacritty](https://alacritty.org/) that incorporates the Celestial color palette.

## Color Palette

The Celestial Alacritty theme uses a balanced 16-color ANSI palette:

**Standard Colors (0-7):**

- Black: `#2a2a2a`
- Red: `#f0544c` - Aliz red for errors and warnings
- Green: `#2eb398` - Teal for success messages
- Yellow: `#f39c12` - Orange for highlights
- Blue: `#3498db` - Keyword blue
- Magenta: `#c678dd` - Purple for special text
- Cyan: `#42a5f5` - Light blue for info
- White: `#cfdcd8` - Default text color

**Bright Colors (8-15):**

- Bright Black: `#7e8e8c` - Comments/dim text
- Bright Red: `#e74c3c` - Emphasized errors
- Bright Green: `#2eb398` - Emphasized success
- Bright Yellow: `#f5b041` - Emphasized highlights
- Bright Blue: `#5ba3e0` - Emphasized info
- Bright Magenta: `#d291e6` - Emphasized special text
- Bright Cyan: `#6dd4f7` - Emphasized cyan
- Bright White: `#ffffff` - Pure white

**UI Colors:**

- Background: `#000000` - Pure black
- Foreground: `#cfdcd8` - Light gray-green
- Cursor: `#7e8e8c` - Muted gray
- Selection: `#3d4d4f` - Dark gray

## Installation

1. Copy the theme file to your Alacritty themes directory (or run `./install.sh --alacritty` from the repository root):

   ```bash
   mkdir -p ~/.config/alacritty/themes
   cp Celestial.toml ~/.config/alacritty/themes/
   ```

2. Import it from your Alacritty configuration file (`~/.config/alacritty/alacritty.toml`):

   ```toml
   [general]
   import = ["~/.config/alacritty/themes/Celestial.toml"]
   ```

3. Alacritty reloads its configuration automatically

## Features

- **True Black Background**: Pure black (`#000000`) for maximum contrast and OLED friendliness
- **85% Background Opacity**: Subtle transparency by default - set `[window]` `opacity = 1.0` in your `alacritty.toml` to disable
- **Balanced Palette**: Colors chosen to work well with common terminal applications
- **Consistent Design**: Matches the Celestial GTK theme aesthetic
