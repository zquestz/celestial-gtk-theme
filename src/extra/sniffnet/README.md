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
- **celestial-aliz-dark.toml** - Coral red accent (`#f0544c`)
- **celestial-azul-dark.toml** - Blue accent (`#3498db`)
- **celestial-pueril-dark.toml** - Green accent (`#97bb72`)

Light variants:

- **celestial-sea-light.toml** - Teal accent (`#2eb398`)
- **celestial-aliz-light.toml** - Coral red accent (`#f0544c`)
- **celestial-azul-light.toml** - Blue accent (`#3498db`)
- **celestial-pueril-light.toml** - Green accent (`#97bb72`)

## Installation

To install the themes, or only the variant you want, run this from the
repository root:

```bash
./install.sh --sniffnet
./install.sh --sniffnet -t sea -c dark
```

The themes go in `~/.local/share/celestial/sniffnet/`, or
`/usr/share/celestial/sniffnet/` for a system-wide install. Like every install
flag, this also installs the matching GTK themes, which `-t` and `-c` narrow
too.

Sniffnet loads a theme from a file path, so you can also skip the installer and
keep a theme file anywhere. To apply one:

1. Open **Sniffnet** and go to **Settings**.

2. Select the **Style** tab and scroll to the custom theme field at the bottom.

3. Enter the full path to the theme file (the installer prints an example).

4. Sniffnet validates the file and applies the theme immediately once the path
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
  - Aliz (coral red) -> teal `#2eb398`
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
