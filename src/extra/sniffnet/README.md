# Celestial Sniffnet Themes

[Sniffnet](https://github.com/GyulyVGC/sniffnet) custom themes that match the
Celestial GTK theme color variants.

## Overview

These themes bring the Celestial color palette to Sniffnet, the cross-platform
network traffic monitor. Each theme corresponds to one of the four Celestial
color schemes, in both dark and light modes, so Sniffnet blends in with the rest
of your Celestial desktop.

## Available Themes

Dark variants:

- **celestial-sea-dark.toml** - Teal accent (`#2eb398`)
- **celestial-aliz-dark.toml** - Red accent (`#f0544c`)
- **celestial-azul-dark.toml** - Blue accent (`#3498db`)
- **celestial-pueril-dark.toml** - Green accent (`#97bb72`)

Light variants:

- **celestial-sea-light.toml** - Teal accent (`#2eb398`)
- **celestial-aliz-light.toml** - Red accent (`#f0544c`)
- **celestial-azul-light.toml** - Blue accent (`#3498db`)
- **celestial-pueril-light.toml** - Green accent (`#97bb72`)

## Installation

Sniffnet loads custom themes directly from a file path - there is no themes
directory to copy into. To apply a Celestial theme:

1. Save your chosen `.toml` file anywhere on your system, for example:

   ```bash
   mkdir -p ~/.config/sniffnet/themes
   cp celestial-sea-dark.toml ~/.config/sniffnet/themes/
   ```

2. Open **Sniffnet** and go to **Settings**.

3. Select the **Style** tab and scroll to the custom theme field at the bottom.

4. Enter the full path to your theme file, e.g.
   `~/.config/sniffnet/themes/celestial-sea-dark.toml`.

5. Sniffnet validates the file and applies the theme immediately once the path
   is valid.

## Theme Format

Each theme defines the six colors Sniffnet supports, in RGB/RGBA hexadecimal:

| Field | Controls |
|-------|----------|
| `primary` | Application background |
| `secondary` | Header, footer, and **incoming** connections |
| `outgoing` | **Outgoing** connections |
| `text_body` | Body text |
| `text_headers` | Header and footer text |
| `starred` | Favorites' star |

## Color Palette

Each theme follows a consistent philosophy:

- **Background** (`primary`): authentic Celestial dark or light background.
- **Incoming / header** (`secondary`): the variant's signature accent color, so
  the header, footer, and incoming traffic all carry the variant's identity.
- **Outgoing** (`outgoing`): a complementary accent drawn from the Celestial
  palette, keeping the two traffic directions easy to tell apart:
  - Sea (teal) -> coral `#f0544c`
  - Aliz (red) -> teal `#2eb398`
  - Azul (blue) -> coral `#f0544c`
  - Pueril (green) -> purple `#c678dd`
- **Body text** (`text_body`): Celestial foreground text for the active mode.
- **Header text** (`text_headers`): high-contrast text on the accent-colored
  header - near-black on the dark themes, white on the light themes.
- **Star** (`starred`): Celestial yellow `#f7dc6f` on dark, deepened to gold
  `#f39c12` on light so it stays visible against the light background.

## Customization

Feel free to tweak any value to taste - the files are small and every color is
commented. Sniffnet re-validates and re-applies as soon as you point it back at
the edited file.

## Resources

- [Sniffnet](https://github.com/GyulyVGC/sniffnet)
- [Sniffnet Custom Themes documentation](https://github.com/GyulyVGC/sniffnet/wiki/Custom-themes)
- [Celestial GTK Theme](https://github.com/zquestz/celestial-gtk-theme)

## License

These themes are part of the Celestial GTK Theme project and are licensed under
the GNU General Public License v3.0.
