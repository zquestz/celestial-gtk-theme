# Celestial Theme for Kitty Terminal

A dark terminal theme for [Kitty](https://sw.kovidgoyal.net/kitty/) that incorporates the Celestial color palette.

## Color Palette

The Celestial Kitty theme uses a balanced 16-color ANSI palette:

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

### Using the Theme Kitten

Kitty includes a built-in theme manager. If you want to use this theme with the theme kitten:

1. Copy the theme file to Kitty's themes directory:

   ```bash
   mkdir -p ~/.config/kitty/themes
   cp Celestial.conf ~/.config/kitty/themes/
   ```

2. Use the theme kitten to select it:

   ```bash
   kitty +kitten themes
   ```

3. Search for "Celestial" and select it

### Using the Installer Script

The Celestial GTK Theme installer can install the Kitty theme for you:

```bash
./install.sh --kitty
```

This will copy the theme to `~/.config/kitty/themes/Celestial.conf`.

**Note:** Kitty themes can only be installed for user accounts (not system-wide).

## Features

- **True Black Background**: Pure black (`#000000`) for maximum contrast and OLED friendliness
- **Balanced Palette**: Colors chosen to work well with common terminal applications
- **Consistent Design**: Matches the Celestial GTK theme aesthetic
