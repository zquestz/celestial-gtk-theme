# Celestial GTK Theme

[![CI](https://img.shields.io/github/actions/workflow/status/zquestz/celestial-gtk-theme/verify.yml?style=flat-square&label=CI)](https://github.com/zquestz/celestial-gtk-theme/actions/workflows/verify.yml) ![Version](https://img.shields.io/badge/Version-1.6.3-blue?style=flat-square) ![License](https://img.shields.io/badge/License-GPL%20v3-blue?style=flat-square) ![GTK Version](https://img.shields.io/badge/GTK-3%20%7C%204-blue?style=flat-square) ![GNOME Shell](https://img.shields.io/badge/GNOME%20Shell-38%20--%2050-blue?style=flat-square) ![KDE Plasma](https://img.shields.io/badge/KDE%20Plasma-6-blue?style=flat-square)

**A modern, customizable GTK theme with multiple color variants**

Based on the excellent [Arc](https://github.com/horst3180/Arc-theme) and [Matcha](https://github.com/vinceliuice/Matcha-gtk-theme) themes

**[Changelog](CHANGELOG.md)** | **[Installation Guide](INSTALL.md)** | **[Development Guide](HACKING.md)**

![Celestial Theme Showcase](https://github.com/zquestz/celestial-gtk-theme/blob/images/showcase.gif?raw=true)

## Features

- **12 Theme Variants** - 4 colors (Sea, Aliz, Azul, Pueril) x 3 modes (Light, Standard, Dark)
- **Desktop Support** - GTK 2/3/4, GNOME Shell (38-50), Cinnamon, Xfce, Budgie, Pantheon, Unity, Openbox, Labwc
- **KDE Plasma Support** - Native theming for KDE Plasma 6
- **Dock Support** - [Plank Reloaded](https://github.com/zquestz/plank-reloaded) theming
- **HiDPI Support** - Standard, HiDPI, and XHiDPI variants for retina displays
- **Color-Matched Backgrounds** - Minimalistic wallpapers coordinated with each theme variant
- **Additional Theming** - GDM login screen, libadwaita apps, GTKSourceView syntax highlighting, cursor theme, Zed editor themes, Alacritty, foot, Ghostty, Kitty, and Konsole terminal themes, Telegram Desktop themes, Halloy IRC client themes, CopyQ clipboard manager themes, Slack themes, Sniffnet network monitor themes

## Installation

For complete installation instructions, requirements, and customization options, see **[INSTALL.md](INSTALL.md)**.

### Quick Start

```bash
git clone https://github.com/zquestz/celestial-gtk-theme.git
cd celestial-gtk-theme
./install.sh
```

This installs all theme variants to `~/.themes/`. For system-wide installation, customization options, and applying the theme to your desktop, see the full [installation guide](INSTALL.md).

## KDE Plasma

Celestial provides native KDE Plasma theming for all 12 variants, including the bundled [Kvantum](src/Kvantum/README.md) themes for Qt apps. The global themes also set [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) icons, the Celestial cursor, and each color's matching wallpaper - install those, plus the matching SDDM login screen, for the complete look.

```bash
# Install all KDE Plasma variants
./install.sh --kde

# Install a specific variant
./install.sh --kde -t azul -c dark

# Install with the Celestial cursors and backgrounds
./install.sh --kde --cursors -b

# Add the matching login screen (system-wide, so it needs root)
sudo ./install.sh --sddm
```

Then apply from **System Settings** > **Global Theme**. One manual step remains: a global theme can select Kvantum as the widget style but can't choose which Celestial _variant_ Kvantum renders, so set it once to match:

```bash
kvantummanager --set Celestial-Azul-Dark
```

GTK/GNOME apps don't follow a Plasma global theme - set them to match under **System Settings** > **Application Style** > **GNOME/GTK Application Style**, selecting your Celestial variant.

The **SDDM login screen** is applied separately: pick your variant under **System Settings** > **Colors & Themes** > **Login Screen (SDDM)**, then click **Apply Plasma Settings** on the same page (a global theme can't switch the login screen, so it's a one-time selection like the Kvantum step).

Built for Plasma 6. See the [KDE Plasma README](src/kde/README.md) for full details.

## GNOME Desktop

Select your Celestial variant in **GNOME Tweaks** > **Appearance**. The shell theme is a separate setting that needs the User Themes extension - see [INSTALL.md](INSTALL.md#gnome-desktop) for both steps.

The panel's **Dark Style** toggle flips GNOME's `color-scheme` preference, which only reaches GTK 4 apps: each installed variant is paired with its color's dark stylesheet, so a light or standard variant switches to dark and back. GTK 3 apps, the shell theme, and Qt apps follow the theme you selected, and a dark variant is already dark - so on a dark variant the toggle looks like it does nothing. To switch the whole desktop, change the theme:

```bash
gsettings set org.gnome.desktop.interface gtk-theme "Celestial-Sea-Light"
gsettings set org.gnome.shell.extensions.user-theme name "Celestial-Sea-Light"
```

### Qt Applications

On GNOME's Wayland session, Qt applications draw their own titlebars - Mutter offers no server-side decorations - so no theme can style them, and Qt's `adwaita` decoration plugin (`qt6-qtwayland-adwaita-decoration` on Fedora, usually preinstalled with GNOME) is hardcoded to the Adwaita look. Two options:

```bash
# GNOME-style Qt titlebars (follows light/dark, but always Adwaita)
QT_WAYLAND_DECORATION=adwaita

# Celestial Qt titlebars: run the app under XWayland, where Mutter
# decorates it from the GTK theme; Kvantum still styles the widgets
QT_QPA_PLATFORM=xcb
```

Set either persistently with a file in `~/.config/environment.d/` (one `VAR=value` per line), then log out and back in. On KDE Plasma none of this applies - KWin draws the Celestial window decorations for every app.

## Recommended Companions

Complete your desktop with these complementary themes:

- **[Papirus Icon Theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)** - Modern icon theme with excellent coverage; pair `Papirus` with the standard variants, `Papirus-Dark` with dark, and `Papirus-Light` with light
- **[Papirus XApp Symbolic Icons](https://github.com/zquestz/papirus-xapp-symbolic-icons)** - Redraws the XApp symbolic icons used by Cinnamon and Linux Mint apps in Papirus style at 16, 22, and 24px, so they stop looking out of place; installs into an existing Papirus theme
- **[Plank Reloaded](https://github.com/zquestz/plank-reloaded)** - Modern dock with Celestial theme support
- **[Hardcode-Tray](https://github.com/bilelmoussaoui/Hardcode-Tray)** - Fix hardcoded tray icons
- **[Folder Color](https://github.com/costales/folder-color)** - Change individual folder colors in Nautilus, Nemo, and Caja
- **[Transparent panels](https://cinnamon-spices.linuxmint.com/extensions/view/81)** - Cinnamon extension with full theme color support

### Matching Folder Colors

Papirus ships folder icons in every Celestial hue, and [papirus-folders](https://github.com/PapirusDevelopmentTeam/papirus-folders) sets which one is the default. Pick the color for your variant, and the Papirus flavor you paired it with:

```bash
papirus-folders -C teal  -t Papirus-Dark -u   # Sea
papirus-folders -C green -t Papirus-Dark -u   # Pueril
papirus-folders -C blue  -t Papirus-Dark -u   # Azul (Papirus default)
papirus-folders -C red   -t Papirus-Dark -u   # Aliz
```

Use `-t Papirus` for the standard variants and `-t Papirus-Light` for light, matching the pairing above. This changes the Papirus theme itself, so it applies everywhere Papirus is used, not just under Celestial - `papirus-folders -D -t <theme>` restores the default blue. The command elevates itself with `sudo` when Papirus is installed system-wide.

### Qt Theming

For a consistent look across GTK and Qt applications, we recommend **[Kvantum](https://github.com/tsujan/Kvantum/tree/master/Kvantum)** - a powerful SVG-based theme engine for Qt applications.

On **KDE Plasma**, `--kde` (see [KDE Plasma](#kde-plasma) above) already installs these Kvantum themes.

Celestial includes Kvantum themes that can be installed with the `-k` flag:

```bash
# Install all Kvantum theme variants
./install.sh --kvantum

# Install specific variant
./install.sh --kvantum -t azul -c dark
```

After installation, use **Kvantum Manager** to select your Celestial theme variant. For more details, see the [Kvantum README](src/Kvantum/README.md).

**Alternative Qt Theming Tools:**

If you prefer a different approach, consider:

- **[qt6gtk2](https://github.com/trialuser02/qt6gtk2)** - Qt6 style plugin that uses GTK2 theme rendering
- **[Qt Style Plugins](https://github.com/qt/qtstyleplugins)** - Qt5 style plugins including GTK2 support

These plugins provide alternative ways to ensure Qt applications (KDE apps, VLC, Telegram, etc.) match your GTK theme.

## Community

**[Celestial Theme Forge](https://github.com/erikdubois/celestial-theme-forge)** by [Erik Dubois](https://github.com/erikdubois) generates Celestial in any accent color you like - 58 colors x light, standard, and dark. It ships a GTK4 picker that lets you grab a color with an eyedropper or a swatch, then builds and installs the theme to `~/.themes`, covering GTK 2/3/4, GNOME Shell, Cinnamon, Xfwm4, Metacity, Openbox, Labwc, Plank, Kvantum, and KDE Plasma color schemes, global themes, desktop themes, and Aurorae decorations.

The generated themes are published ready to use at **[celestial-themes](https://github.com/erikdubois/celestial-themes)**.

## Cursor Theme

Celestial includes a modern cursor theme designed to complement all theme variants.

To install the cursor theme:

```bash
./install.sh --cursors
```

For more details, see the [Cursors README](src/cursors/README.md).

## Code Editor Themes

Celestial includes syntax highlighting themes for popular code editors:

### GTKSourceView

For editors like Xed and other GTKSourceView-based applications, Celestial provides a comprehensive syntax highlighting theme with a carefully crafted color palette.

The GTKSourceView theme is automatically installed when you run the standard installation:

```bash
./install.sh
```

The theme file is installed to `~/.local/share/gtksourceview-4/styles/celestial.xml` (or `/usr/share/gtksourceview-4/styles/` for system-wide installations).

### Zed Editor

For [Zed](https://zed.dev/) users, Celestial provides 8 themes - 4 color variants (Aliz, Azul, Pueril, Sea) with both dark and light modes that match the GTK theme color palette.

To install all Zed themes:

```bash
./install.sh --zed
```

To install specific variant(s):

```bash
./install.sh --zed -t azul
./install.sh --zed -t sea -t aliz
```

Then select your theme from Zed's theme selector (Cmd+K Cmd+T or Ctrl+K Ctrl+T):

- Celestial Aliz Dark / Light
- Celestial Azul Dark / Light
- Celestial Pueril Dark / Light
- Celestial Sea Dark / Light

For more details, see the [Zed theme README](src/extra/zed/README.md).

**Note:** Zed themes can only be installed for user accounts (not system-wide).

## Terminal Themes

Celestial includes color themes for popular terminal emulators:

### Alacritty Terminal

For [Alacritty](https://alacritty.org/) terminal users, Celestial provides a terminal theme that incorporates the Celestial color palette.

To install the Alacritty theme:

```bash
./install.sh --alacritty
```

Then import it from your `alacritty.toml` with `[general]` `import = ["~/.config/alacritty/themes/Celestial.toml"]`. For more details, see the [Alacritty theme README](src/extra/alacritty/README.md).

**Note:** Alacritty themes can only be installed for user accounts (not system-wide).

### foot Terminal

For [foot](https://codeberg.org/dnkl/foot) terminal users, Celestial provides a terminal theme that incorporates the Celestial color palette.

To install the foot theme:

```bash
./install.sh --foot
```

Then add `include=~/.config/foot/themes/Celestial` to the top of your `foot.ini`. For more details, see the [foot theme README](src/extra/foot/README.md).

### Ghostty Terminal

For [Ghostty](https://ghostty.org/) terminal users, Celestial provides a terminal theme that incorporates the Celestial color palette.

To install the Ghostty theme:

```bash
./install.sh --ghostty
```

Then set `theme = "Celestial"` in your Ghostty configuration file. For more details, see the [Ghostty theme README](src/extra/ghostty/README.md).

### Kitty Terminal

For [Kitty](https://sw.kovidgoyal.net/kitty/) terminal users, Celestial provides a terminal theme that incorporates the Celestial color palette.

To install the Kitty theme:

```bash
./install.sh --kitty
```

Then use the Kitty theme kitten (`kitty +kitten themes`) to select "Celestial", or include the theme in your `kitty.conf`. For more details, see the [Kitty theme README](src/extra/kitty/README.md).

**Note:** Kitty themes can only be installed for user accounts (not system-wide).

### Konsole Terminal

For [Konsole](https://konsole.kde.org/) and [Yakuake](https://apps.kde.org/yakuake/) users, Celestial provides a terminal color scheme that matches the palette. It is installed with the KDE Plasma themes:

```bash
./install.sh --kde
```

Then in Konsole: **Settings** > **Edit Current Profile** > **Appearance** and select the **Celestial** scheme. For more details, see the [Konsole theme README](src/extra/konsole/README.md).

## Clipboard Manager Themes

### CopyQ

For [CopyQ](https://github.com/hluk/CopyQ) clipboard manager users, Celestial provides 8 themes - 4 color variants (Aliz, Azul, Pueril, Sea) with both dark and light modes that match the GTK theme color palette.

To install all CopyQ themes:

```bash
./install.sh --copyq
```

To install specific variant(s):

```bash
./install.sh --copyq -t azul
./install.sh --copyq -t sea -c dark
```

CopyQ themes are installed to `~/.config/copyq/themes/` for user installs or `/usr/share/copyq/themes/` for system-wide installs.

Then in CopyQ: **File** > **Preferences** > **Appearance** > Select theme from dropdown menu

Available themes:

- Celestial Aliz Dark / Light
- Celestial Azul Dark / Light
- Celestial Pueril Dark / Light
- Celestial Sea Dark / Light

For more details and installation instructions, see the [CopyQ theme README](src/extra/copyq/README.md).

## Communication App Themes

### Halloy IRC Client

For [Halloy](https://github.com/squidowl/halloy) IRC client users, Celestial provides 4 dark themes - one for each color variant (Aliz, Azul, Pueril, Sea) that match the GTK theme color palette.

To install all Halloy themes:

```bash
./install.sh --halloy
```

To install specific variant(s):

```bash
./install.sh --halloy -t azul
./install.sh --halloy -t sea -t aliz
```

Halloy themes are installed to `~/.config/halloy/themes/`. Then in your Halloy `config.toml`, set:

```toml
theme = "celestial-sea"
```

For more details and installation instructions, see the [Halloy theme README](src/extra/halloy/README.md).

**Note:** Halloy themes can only be installed for user accounts (not system-wide).

### Telegram Desktop

For [Telegram Desktop](https://desktop.telegram.org/) users, Celestial provides 8 color palettes - 4 color variants (Sea, Aliz, Azul, Pueril) in light and dark.

Message bubbles stay neutral and are separated by elevation, with the accent reserved for links, controls, and the selected chat. Each theme also sets a flat Celestial chat background, replacing Telegram's patterned default.

To install one, open the theme file for your variant with Telegram Desktop:

```bash
xdg-open src/extra/telegram/Celestial-Sea-Dark.tdesktop-theme
```

Double-clicking the file or dragging it onto the Telegram window works too.

For more details, see the [Telegram theme README](src/extra/telegram/README.md).

### Slack

For [Slack](https://slack.com/) users, Celestial provides 8 custom themes - 4 color variants (Aliz, Azul, Pueril, Sea) with both dark and light modes that match the GTK theme color palette.

Slack themes are simple copy-paste installations:

1. Open Slack
2. Click on your workspace name in the top-left
3. Go to **Preferences** > **Appearance** > **Custom theme**
4. Copy and paste one of the theme codes from the [Slack theme README](src/extra/slack/README.md)

Available themes:

- Celestial Aliz Dark / Light
- Celestial Azul Dark / Light
- Celestial Pueril Dark / Light
- Celestial Sea Dark / Light

Each theme uses a simple 4-value format: `background,accent,accent,accent` where the accent color is used for selected items, presence indicators, and notifications.

For theme codes and more details, see the [Slack theme README](src/extra/slack/README.md).

## Network Monitor Themes

### Sniffnet

For [Sniffnet](https://github.com/GyulyVGC/sniffnet) network monitor users, Celestial provides 8 themes - 4 color variants (Aliz, Azul, Pueril, Sea) with both dark and light modes that match the GTK theme color palette.

Sniffnet loads custom themes from a file path - there is no installer step:

1. Open **Sniffnet** and go to **Settings**
2. Select the **Style** tab and scroll to the custom theme field at the bottom
3. Enter the full path to one of the theme files in `src/extra/sniffnet/` (e.g. `celestial-sea-dark.toml`)
4. Sniffnet validates the file and applies it immediately

Available themes:

- Celestial Aliz Dark / Light
- Celestial Azul Dark / Light
- Celestial Pueril Dark / Light
- Celestial Sea Dark / Light

For more details, see the [Sniffnet theme README](src/extra/sniffnet/README.md).

## Development

### Building from Source

If you modify SCSS files, rebuild the CSS:

```bash
./parse_sass.sh
```

This will regenerate all CSS files from SCSS sources.

## Screenshots

### Dark Themes

#### Aliz Dark

![Aliz Dark](https://github.com/zquestz/celestial-gtk-theme/blob/images/aliz-dark.png?raw=true)

#### Azul Dark

![Azul Dark](https://github.com/zquestz/celestial-gtk-theme/blob/images/azul-dark.png?raw=true)

#### Pueril Dark

![Pueril Dark](https://github.com/zquestz/celestial-gtk-theme/blob/images/pueril-dark.png?raw=true)

#### Sea Dark

![Sea Dark](https://github.com/zquestz/celestial-gtk-theme/blob/images/sea-dark.png?raw=true)

### Light Themes

#### Aliz Light

![Aliz Light](https://github.com/zquestz/celestial-gtk-theme/blob/images/aliz-light.png?raw=true)

#### Azul Light

![Azul Light](https://github.com/zquestz/celestial-gtk-theme/blob/images/azul-light.png?raw=true)

#### Pueril Light

![Pueril Light](https://github.com/zquestz/celestial-gtk-theme/blob/images/pueril-light.png?raw=true)

#### Sea Light

![Sea Light](https://github.com/zquestz/celestial-gtk-theme/blob/images/sea-light.png?raw=true)

### Standard Themes

#### Aliz

![Aliz](https://github.com/zquestz/celestial-gtk-theme/blob/images/aliz.png?raw=true)

#### Azul

![Azul](https://github.com/zquestz/celestial-gtk-theme/blob/images/azul.png?raw=true)

#### Pueril

![Pueril](https://github.com/zquestz/celestial-gtk-theme/blob/images/pueril.png?raw=true)

#### Sea

![Sea](https://github.com/zquestz/celestial-gtk-theme/blob/images/sea.png?raw=true)

## Troubleshooting

For troubleshooting common issues, see the [Troubleshooting section in INSTALL.md](INSTALL.md#troubleshooting).

## Contributing

Contributions are welcome! For development guidelines and detailed instructions, see [HACKING.md](HACKING.md).

**Quick Start:**

1. Fork and create a feature branch
2. Edit SCSS files in `src/*/sass/` directories
3. Compile with `./parse_sass.sh`
4. Test with `./install.sh -t azul -c dark`
5. Submit a pull request

## Credits

**Celestial GTK Theme** is based on:

- **Arc GTK Theme** by [horst3180](https://github.com/horst3180/Arc-theme)
- **Matcha GTK Theme** by [Vince Liuice](https://github.com/vinceliuice/Matcha-gtk-theme)

**Customized and maintained by:**

- [zquestz](https://github.com/zquestz)

Special thanks to all [contributors](AUTHORS.md) who have helped improve this theme!

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE.md](LICENSE.md) file for details.

## Support

If you like this theme, please consider:

- Starring the repository
- Reporting bugs or requesting features
- Contributing code improvements
- Sharing with others

**Made with care for the Linux community**
