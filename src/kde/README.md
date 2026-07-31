# KDE Plasma Themes

This directory contains native theming for the KDE Plasma desktop.

## What's Included

- **Color schemes** (`color-schemes/`) - 12 `.colors` files (4 colors x standard/light/dark) that theme every Qt and KDE application, window titlebars, and headers to match the Celestial palette.
- **Global themes** (`look-and-feel/`) - 12 "Look and Feel" packages that appear under **System Settings > Global Theme**. Each bundles the matching color scheme, the Kvantum widget style, Breeze window decorations, a dark/light Plasma panel, Papirus icons, the Celestial cursor, a Celestial splash screen, and preview images - so a single click themes the whole desktop.
- **Desktop themes** (`desktoptheme/`) - 12 Plasma desktop themes covering the full widget set (panel, popups, tooltips, tasks, sliders, and more), built on Arc's proven artwork and recolored live from each variant's Celestial color scheme. The standard variants keep a dark panel while their app windows stay light.
- **Window decorations** (`aurorae/`) - 12 Aurorae packages that give windows Celestial's titlebars and buttons, built from the GTK theme's own titlebutton designs - including the plain close X that only turns red on hover.
- **Login screens** (`sddm/`) - 12 SDDM themes with each variant's palette baked into the login screen, installed system-wide with `sudo ./install.sh --sddm`.

The Kvantum widget themes referenced by the global themes live in [`../Kvantum`](../Kvantum), and a matching [Konsole](../extra/konsole) terminal scheme lives in `../extra/konsole`. Everything except the login screen is installed together by the `--kde` flag; the SDDM themes are system-wide, so they have their own `sudo ./install.sh --sddm` step.

## Installation

```bash
# Install all KDE Plasma variants
./install.sh --kde

# Install a specific variant
./install.sh --kde -t azul -c dark

# Install with the Celestial cursors and backgrounds
./install.sh --kde --cursors -b
```

This installs to:

- User installation:
  - Color schemes: `~/.local/share/color-schemes/`
  - Global themes: `~/.local/share/plasma/look-and-feel/`
  - Desktop themes: `~/.local/share/plasma/desktoptheme/`
  - Window decorations: `~/.local/share/aurorae/themes/`
  - Konsole scheme: `~/.local/share/konsole/`
  - Kvantum themes: `~/.config/Kvantum/`
- System installation (with sudo): the corresponding `/usr/share/...` directories.
- SDDM login themes (`sudo ./install.sh --sddm`): `/usr/share/sddm/themes/` - always system-wide, since the login screen runs before any user session.

Built for Plasma 6. The color schemes also work on Plasma 5, but the global-theme packages use the Plasma 6 `metadata.json` format.

## Applying the Theme

1. **Global theme** - **System Settings > Global Theme**, pick your Celestial variant. This sets the color scheme, the Kvantum widget style, the Celestial window decorations, a dark/light Plasma panel, Papirus icons, the Celestial cursor, the color's matching wallpaper, and the Celestial splash screen. (You may want to leave "Use desktop layout from theme" unchecked so your panel arrangement is preserved.)

   Prefer just the colors? **System Settings > Colors** lets you apply a Celestial color scheme without changing anything else.

2. **Kvantum variant** - a global theme can select _Kvantum_ as the widget style but cannot tell Kvantum _which_ Celestial variant to render, because that lives in Kvantum's own config. Set it once to match:

   ```bash
   kvantummanager --set Celestial-Azul-Dark
   ```

   or use the **Kvantum Manager** GUI (Change/Install Theme > select the variant > Use this theme). If you switch global themes later, run this again with the new variant name. Kvantum only reads its config at startup, so relaunch any open Qt apps to see the change.

3. **Konsole** - **Settings > Edit Current Profile > Appearance**, then select the **Celestial** color scheme. (Konsole cursor and selection colors are profile settings, not part of the scheme.)

4. **GTK / GNOME apps** - select your Celestial variant under **System Settings > Application Style > GNOME/GTK Application Style** (a global theme can't set the GTK theme, so it's a one-time selection like the Kvantum step above).

5. **Login screen** - after `sudo ./install.sh --sddm`, pick your variant under **System Settings > Colors & Themes > Login Screen (SDDM)**, then click **Apply Plasma Settings** on the same page. Login text fields take their colors from the greeter's own color scheme, and that button copies your active Celestial scheme (and cursor) to it - without it they fall back to Breeze colors. The background defaults to the color's wallpaper - the same image the global theme sets; the same page can pick a different one per theme (stored in `theme.conf.user`, so reinstalling the theme keeps your choice).

## Theme Variants

Color schemes and global themes are provided for every variant:

- **Sea** (Teal) - Standard, Light, Dark
- **Aliz** (Crimson) - Standard, Light, Dark
- **Azul** (Blue) - Standard, Light, Dark
- **Pueril** (Green) - Standard, Light, Dark

The **Standard** variants reproduce Celestial's signature look - light application bodies with dark window titlebars and headers.

## Requirements

The global themes set the icon theme to **Papirus** and the cursor to **Celestial**, so install those for the intended look. (The theme still applies without them.)

- **[Papirus Icon Theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)** - `Papirus` for the standard variants, `Papirus-Dark` for dark, `Papirus-Light` for light
- The **Celestial cursor theme** - `./install.sh --cursors`
- The **Celestial backgrounds** - `./install.sh --kde -b` - each global theme sets its color's wallpaper
- The **Celestial SDDM themes** - `sudo ./install.sh --sddm` - a matching login screen for every variant
- The **Aurorae** decoration engine - ships with Plasma (the `aurorae` package); without it KWin falls back to Breeze decorations

## Development

The `color-schemes/`, `look-and-feel/`, `desktoptheme/`, `aurorae/`, and `sddm/` directories are generated by `render.sh` from the GTK sass palette - the script is their source, so never edit those files by hand. The login theme sources live in `sddm-base/`: the Breeze SDDM QML (LGPL) with the Kirigami colors pinned per variant via `{{TOKEN}}`s, because the greeter has no color scheme configuration of its own. The decoration inputs live in `aurorae-base/`: the window frames are vendored from [arc-kde](https://github.com/PapirusDevelopmentTeam/arc-kde) (tokenized, pinned to `b67cdb7`), and the button templates carry Celestial's own GTK titlebutton artwork with per-variant colors extracted from `../gtk/assets-*.svg` (the `button_colors` table in `render.sh`; re-extract if the GTK titlebuttons change). After changing colors in `../gtk/sass/_colors.scss`, run:

```bash
./src/kde/render.sh
```

This requires `sassc`, `rsvg-convert`, and ImageMagick. Each global-theme package contains `metadata.json`, `contents/defaults`, `contents/colors` (a bundled copy of the color scheme), and `contents/previews/` images (`preview.png` and the fullscreen `fullscreenpreview.jpg`), rendered from `preview-template.svg`. The desktop themes' widget SVGs live in `desktoptheme-base/` - Celestial's own base, originally adapted from [arc-kde](https://github.com/PapirusDevelopmentTeam/arc-kde). They are stylesheet-based (`ColorScheme-*` classes), so Plasma recolors them at runtime from each package's bundled colors file; surfaces are flattened to full opacity to match Celestial's solid style, and standard variants bundle their color's dark `.colors` so the panel stays dark. Two things Plasma is strict about: each global-theme package folder **must** be named exactly after its `KPlugin` Id, and the color scheme only applies if it is bundled as `contents/colors` (the `ColorScheme=` line in `defaults` just sets the label).

## Credits

The KDE theming structure is based on [Matcha-kde](https://github.com/vinceliuice/Matcha-kde) by Vince Liuice. The window decoration frames and the Plasma desktop theme artwork are from [arc-kde](https://github.com/PapirusDevelopmentTeam/arc-kde) by Alexey Varfolomeev, recolored for Celestial. The SDDM login themes are derived from the Breeze SDDM theme (LGPL-2.0-or-later) by David Edmundson and the KDE Visual Design Group, with the Celestial palette baked in.
