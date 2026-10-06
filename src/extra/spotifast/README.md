# Celestial Spotifast Themes

[Spotifast](https://spotifast.rocks/) palettes that match the Celestial GTK
theme color variants.

## Overview

Spotifast is a lightweight native Spotify client. It reads JSON palettes from
`~/.config/spotifast/themes/` and lists each one in its theme picker under its
file name, so these files are named the way Spotifast's own palettes are.

Every palette is generated from the compiled GTK stylesheets. Each color comes
in Light and Dark. Celestial's Standard mode pairs light content with dark
chrome such as titlebars, menubars, and sidebars, but a Spotifast palette has
one set of text colors for every surface, so a dark sidebar would hide its
text. If you use a Standard variant, pick Light.

## Available Themes

| Color  | Accent    | Light                         | Dark                         |
| ------ | --------- | ----------------------------- | ---------------------------- |
| Aliz   | `#f0544c` | `Celestial Aliz Light.json`   | `Celestial Aliz Dark.json`   |
| Azul   | `#3498db` | `Celestial Azul Light.json`   | `Celestial Azul Dark.json`   |
| Pueril | `#97bb72` | `Celestial Pueril Light.json` | `Celestial Pueril Dark.json` |
| Sea    | `#2eb398` | `Celestial Sea Light.json`    | `Celestial Sea Dark.json`    |

## Installation

Install all eight palettes with the Celestial installer:

```bash
./install.sh --spotifast
```

Or narrow it to the colors and modes you want:

```bash
./install.sh --spotifast -t sea -c dark
```

The palettes go to `~/.config/spotifast/themes/`. Spotifast only reads palettes
from your own config directory, so they cannot be installed system-wide.

To install one by hand, copy its `.json` file into that folder. The **Open
themes folder** button next to Spotifast's theme picker creates the folder and
opens it.

## Selecting a Theme

1. If Spotifast is already running, run `spotifast reload-themes` so it picks
   up the new files. Restarting it works too.
2. Open **Settings** > **Appearance** > **Theme** and choose a Celestial
   palette.

Spotifast's **Colour from album art** setting, in the same section and on by
default, colors parts of the interface from the playing album's artwork. Turn
it off to keep Celestial's colors throughout.

## Color Mapping

Every color comes from the variant's compiled GTK 4 stylesheet:

| Key              | Spotifast uses it for                      | Celestial source                         |
| ---------------- | ------------------------------------------ | ---------------------------------------- |
| `window`         | Main content area                          | `view_bg_color`                          |
| `panel`          | Sidebar and player bar                     | `window_bg_color`                        |
| `surface`        | Buttons, fields, and chips                 | `window_fg_color` at 8% over `window`    |
| `surface_hover`  | Hovered widgets                            | `window_fg_color` at 12% over `window`   |
| `surface_active` | Pressed widgets                            | `window_fg_color` at 18% over `window`   |
| `outline`        | Separators and popup borders               | `borders`                                |
| `text`           | Main text                                  | `window_fg_color`                        |
| `secondary`      | Secondary text                             | `window_fg_color` at 70% over `window`   |
| `dim`            | Disabled text                              | `insensitive_fg_color`                   |
| `accent`         | Highlights, selection, and primary buttons | `accent_bg_color`                        |
| `accent_hover`   | Hovered primary buttons                    | The background of a hovered selected row |
| `on_accent`      | Text on the accent                         | `accent_fg_color`                        |
| `danger`         | Errors                                     | `error_color`                            |
| `warning`        | Warnings                                   | `warning_color`                          |
| `overlay`        | Menus, popups, and dialogs                 | `popover_bg_color`                       |

Translucent GTK colors are flattened over `window`. Spotifast draws buttons,
fields, and chips without borders, while GTK's button colors rely on one, and
GTK's dimmed text is the same as its disabled text in the light variants. So
the three widget fills and the secondary text use the ratios from Spotifast's
own Omarchy template, applied to Celestial's colors. `shadow` is left to
Spotifast's default, as its bundled palettes leave it.

## Development

The palettes are generated from the compiled GTK stylesheets. From the
repository root:

```bash
./src/extra/spotifast/render.sh
```

Change a palette in `src/gtk/sass/_colors.scss`, run `./parse_sass.sh`, then
rerun the generator. CI regenerates and fails if the committed output is stale.
Do not edit the generated palettes directly.

## Resources

- [Spotifast](https://spotifast.rocks/)
- [Spotifast custom themes documentation](https://spotifast.rocks/settings-and-files/#custom-themes)
- [Celestial GTK Theme](https://github.com/zquestz/celestial-gtk-theme)

## License

These themes are part of the Celestial GTK Theme project and are licensed under
the GNU General Public License v3.0.
