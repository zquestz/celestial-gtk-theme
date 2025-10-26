# Celestial Theme for Ghostty

A dark terminal theme for [Ghostty](https://ghostty.org/) that incorporates the Celestial color palette.

## Color Palette

The Celestial Ghostty theme uses a balanced 16-color ANSI palette:

**Standard Colors (0-7):**

- Black: `#2a2a2a`
- Red: `#f0544c` - Aliz red for errors and warnings
- Green: `#2eb398` - Teal for success messages
- Yellow: `#F39C12` - Orange for highlights
- Blue: `#3498db` - Keyword blue
- Magenta: `#c678dd` - Purple for special text
- Cyan: `#42A5F5` - Light blue for info
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

### Linux / macOS

1. Copy the theme file to your Ghostty themes directory:

   ```bash
   mkdir -p ~/.config/ghostty/themes
   cp Celestial ~/.config/ghostty/themes/
   ```

2. Edit your Ghostty configuration file (`~/.config/ghostty/config`):

   ```
   theme = "Celestial"
   ```

3. Restart Ghostty or reload the configuration

## Features

- **True Black Background**: Pure black (`#000000`) for maximum contrast and OLED friendliness
- **Balanced Palette**: Colors chosen to work well with common terminal applications
- **Consistent Design**: Matches the Celestial GTK theme aesthetic
