# KDE Plasma Themes

This directory contains native theming for the KDE Plasma desktop.

## What's Included

- **Color schemes** (`color-schemes/`) - 12 `.colors` files (4 colors x standard/light/dark) that theme every Qt and KDE application, window titlebars, and headers to match the Celestial palette.
- **Global themes** (`look-and-feel/`) - 12 "Look and Feel" packages that appear under **System Settings > Global Theme**. Each bundles the matching color scheme, the Kvantum widget style, Breeze window decorations, a dark/light Plasma panel, Papirus icons, the Celestial cursor, the Breeze splash screen, and preview images - so a single click themes the whole desktop.
- **Desktop themes** (`desktoptheme/`) - 4 minimal Plasma desktop themes (one per color) that give the **standard** variants a dark panel while their app windows stay light. Installed automatically with the standard variants; dark/light variants use Breeze following the color scheme.

The Kvantum widget themes referenced by the global themes live in [`../Kvantum`](../Kvantum), and a matching [Konsole](../extra/konsole) terminal scheme lives in `../extra/konsole`. Everything is installed together by the `--kde` flag.

## Installation

```bash
# Install all KDE Plasma variants
./install.sh --kde

# Install a specific variant
./install.sh --kde -t azul -c dark
```

This installs to:

- User installation:
  - Color schemes: `~/.local/share/color-schemes/`
  - Global themes: `~/.local/share/plasma/look-and-feel/`
  - Desktop themes: `~/.local/share/plasma/desktoptheme/`
  - Konsole scheme: `~/.local/share/konsole/`
  - Kvantum themes: `~/.config/Kvantum/`
- System installation (with sudo): the corresponding `/usr/share/...` directories.

Built for Plasma 6. The color schemes also work on Plasma 5, but the global-theme packages use the Plasma 6 `metadata.json` format.

## Applying the Theme

1. **Global theme** - **System Settings > Global Theme**, pick your Celestial variant. This sets the color scheme, the Kvantum widget style, Breeze window decorations, a dark/light Plasma panel, Papirus icons, the Celestial cursor, and the Breeze splash screen. (You may want to leave "Use desktop layout from theme" unchecked so your panel arrangement is preserved.)

   Prefer just the colors? **System Settings > Colors** lets you apply a Celestial color scheme without changing anything else.

2. **Kvantum variant** - a global theme can select _Kvantum_ as the widget style but cannot tell Kvantum _which_ Celestial variant to render, because that lives in Kvantum's own config. Set it once to match:

   ```bash
   kvantummanager --set Celestial-Azul-Dark
   ```

   or use the **Kvantum Manager** GUI (Change/Install Theme > select the variant > Use this theme). If you switch global themes later, run this again with the new variant name.

3. **Konsole** - **Settings > Edit Current Profile > Appearance**, then select the **Celestial** color scheme. (Konsole cursor and selection colors are profile settings, not part of the scheme.)

4. **GTK / GNOME apps** - select your Celestial variant under **System Settings > Application Style > GNOME/GTK Application Style** (a global theme can't set the GTK theme, so it's a one-time selection like the Kvantum step above).

## Theme Variants

Color schemes and global themes are provided for every variant:

- **Sea** (Teal) - Standard, Light, Dark
- **Aliz** (Crimson) - Standard, Light, Dark
- **Azul** (Blue) - Standard, Light, Dark
- **Pueril** (Green) - Standard, Light, Dark

The **Standard** variants reproduce Celestial's signature look - light application bodies with dark window titlebars and headers.

## Requirements

The global themes set the icon theme to **Papirus** and the cursor to **Celestial**, so install those for the intended look. (The theme still applies without them.)

- **[Papirus Icon Theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)** - `Papirus-Dark` for the dark and standard variants, `Papirus-Light` for the light variants
- The **Celestial cursor theme** - `./install.sh --cursors`

## Development

The color schemes, global-theme packages, desktop themes, and previews are all generated from the GTK sass palette so they never drift. After changing colors in `../gtk/sass/_colors.scss`, regenerate:

```bash
./src/kde/render.sh
```

This requires `sassc`, `rsvg-convert`, and ImageMagick. It rewrites `color-schemes/`, `look-and-feel/`, and `desktoptheme/` (the 4 dark-panel themes, each reusing the matching dark `.colors`) - including each global-theme package's `metadata.json`, `contents/defaults`, `contents/colors` (a bundled copy of the color scheme), and the `contents/previews/` images: `preview.png` (grid thumbnail) and `fullscreenpreview.jpg` (the KCM's "Show Preview"), both rendered from `preview-template.svg`. Two things Plasma is strict about: each global-theme package folder **must** be named exactly after its `KPlugin` Id, and the color scheme only applies if it is bundled as `contents/colors` (the `ColorScheme=` line in `defaults` just sets the label).

## Credits

The KDE theming structure is based on [Matcha-kde](https://github.com/vinceliuice/Matcha-kde) by Vince Liuice, adapted for Celestial.
