# Celestial Theme for Konsole

A dark terminal color scheme for [Konsole](https://konsole.kde.org/) (and [Yakuake](https://apps.kde.org/yakuake/)) that incorporates the Celestial color palette. It matches the Ghostty and Kitty terminal themes.

## Color Palette

The Celestial Konsole scheme uses a balanced 16-color ANSI palette:

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

## Installation

### Using the Installer Script

The Konsole scheme is installed together with the KDE Plasma themes:

```bash
./install.sh --kde
```

This copies the scheme to `~/.local/share/konsole/Celestial.colorscheme` (or `/usr/share/konsole/` for system-wide installs with sudo).

### Manual Installation

If you only want the Konsole scheme, copy the file directly:

```bash
mkdir -p ~/.local/share/konsole
cp Celestial.colorscheme ~/.local/share/konsole/
```

## Applying the Scheme

Konsole color schemes are set per-profile:

1. Open **Settings** > **Edit Current Profile** (or **Manage Profiles** > select a profile > **Edit**)
2. Go to the **Appearance** tab
3. Select the **Celestial** color scheme
4. Click **OK**, then **Apply**

Yakuake uses the same scheme files, so "Celestial" will appear in its profile appearance settings too.

## Features

- **True Black Background**: Pure black (`#000000`) for maximum contrast and OLED friendliness
- **Subtle Transparency**: 85% opacity (requires desktop compositing); adjust it in the profile's Appearance tab if you prefer opaque
- **Consistent Design**: Matches the Celestial Ghostty and Kitty terminal themes

**Note:** Cursor and selection colors are Konsole *profile* settings, not part of the color scheme, so they keep your profile defaults.
