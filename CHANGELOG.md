# Changelog

All notable changes to the Celestial GTK Theme will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- GNOME Calculator's display no longer shows a seam around the backspace button, caused by the theme overriding the app's transparent textviews ([#10](https://github.com/zquestz/celestial-gtk-theme/issues/10))

## [1.6.3] - 2026-08-15

### Changed

- Cinnamon panel hover, focus, checked, and urgent backgrounds are now slightly translucent so transparent panels show through

### Fixed

- Cinnamenu's search entry now matches the stock menu's search entry, instead of picking up a stale override meant for the pre-rename Cinnamon menu

## [1.6.2] - 2026-08-13

### Added

- Link to Papirus XApp Symbolic Icons in the README

### Fixed

- Cinnamon window list items keep the attention color while hovered, instead of falling back to the neutral panel hover background

## [1.6.1] - 2026-08-07

### Added

- Telegram Desktop themes for every variant, in light and dark, with a flat chat background
- Four new backgrounds, one for each color variant: Sea Glacier, Aliz Canyon, Azul Delta, and Pueril Hills
- Link to the Celestial Theme Forge in the README

## [1.6.0] - 2026-07-30

### Added

- GNOME Shell 49 and 50 support, including the renamed scrollbar and notification widgets, the light panel hairline, and the GNOME 50 parental controls lock screen
- Alacritty terminal theme with `--alacritty` installation flag
- foot terminal theme with `--foot` installation flag
- Celestial SDDM login themes for every variant with `--sddm` installation flag

### Changed

- Terminal themes now default to 85% background opacity, matching Konsole (Alacritty, foot, Ghostty, Kitty)
- GNOME Shell tooltips, entries, and text buttons now use Celestial's button shape instead of GNOME's pill shape
- GNOME Shell overview search field, dash, app folders, and screenshot panel now use Celestial's container radius instead of GNOME's large rounded corners
- GNOME Shell popovers, the window switcher, and search sections now share the same corner radius as dialogs

### Removed

- GDM support for GNOME 44 and older, and the Ubuntu 18.04/20.04 login screen paths
- Firefox userChrome theme - Firefox's default theme follows the system GTK theme, and the upcoming Firefox redesign would break it

### Fixed

- GDM theme now works on GNOME 45 and newer, which renamed the login screen stylesheets; it previously replaced the system resource with one the shell could not load

## [1.5.2] - 2026-07-29

### Fixed

- Disabled toolbar and header button labels are now readable in standard variants (Caja, Thunar, Nemo, headerbars) (#9)

## [1.5.1] - 2026-07-28

### Fixed

- Cinnamon window switcher now uses dark colors on its dark surface in light theme variants
- Cinnamon on-screen keyboard now uses dark keys on its dark surface in light theme variants

## [1.5.0] - 2026-07-23

### Added

- Celestial splash screen for the KDE global themes
- Celestial Plasma desktop themes for every variant, covering the full widget set with each variant's palette

### Changed

- Kvantum themes now derive their metrics and scrollbar colors from the GTK theme
- KDE view text now uses the GTK foreground color, fixing dim sidebar text in Dolphin
- Kvantum selections no longer dim their text in unfocused views
- KDE dark variants no longer shift selected-item text color when focus moves between panes
- Kvantum dark variants now use the header color for the menubar and toolbar
- Standard variants now pair with Papirus icons (GTK metatheme and KDE global themes)
- KDE window decorations now default to tiny borders

## [1.4.1] - 2026-07-22

### Added

- Celestial window decorations (Aurorae) for KDE Plasma, applied by the global themes
- Plasma wallpaper packages for the Celestial backgrounds (`--kde -b`); each global theme sets its color's wallpaper

### Changed

- Kvantum themes now enable Dolphin's transparent view

## [1.4.0] - 2026-07-21

### Added

- KDE Plasma 6 support with `--kde` installation flag
- Konsole terminal color scheme

## [1.3.5] - 2026-07-16

### Changed

- Updated Kvantum themes to fix transparency/blur issues in XFCE

## [1.3.4] - 2026-06-28

### Added

- Added themes for Sniffnet

## [1.3.3] - 2026-02-01

### Changed

- Allow `--dest` directory to not exist for packaging environments

## [1.3.2] - 2025-12-12

### Changed

- Fixed Metacity close button being red by default instead of only on hover
- Fixed Metacity minimize/maximize button hover colors to match GTK 3/4
- Fixed Metacity Pueril close button using green instead of red
- Removed border from Metacity minimize/maximize buttons on hover to match GTK 3/4

## [1.3.1] - 2025-12-11

### Changed

- Plank dock now uses dark background consistently across all theme variants
- Plank dock background and stroke colors now match each theme's color palette
- Papirus-Dark is now the recommended icon theme for all variants
- Refactored Cinnamon custom SCSS into modular files in `sass/custom/` folder
- Fixed panel applet icon not turning white when checked/active (e.g., start menu)
- Fixed Pueril close button using green instead of red like other variants

## [1.3.0] - 2025-12-10

### Added

- Full support for Cinnamon 6.6

### Changed

- Restructured Cinnamon theme to match upstream Cinnamon 6.6 SASS architecture
- Notification badges now use theme accent color
- Removed unused Cinnamon assets

## [1.2.0] - 2025-11-21

### Added

- Halloy IRC client themes with `--halloy` installation flag
  - 4 dark theme variants matching each Celestial color (Sea, Aliz, Azul, Pueril)
  - Installed to `~/.config/halloy/themes/`
  - User-only installation (no system-wide support)

## [1.1.9] - 2025-11-11

### Changed

- Redesigned color-picker cursor and updated cursor hotspot

## [1.1.8] - 2025-11-10

### Added

- New Celestial cursor theme with `--cursors` installation flag
  - Modern, clean cursor design with flat icon-style aesthetic
  - Progress/wait animations using Celestial color palette (red, orange, yellow, teal, blue, purple)
  - HiDPI support with multiple resolutions (x1, x1.25, x1.5, x2)
  - Wayland and X11 compatibility
  - Unified theme works beautifully with all four Celestial color variants

## [1.1.7] - 2025-11-06

### Added

- New background wallpapers for all theme variants
  - Aliz-Volcano.webp - Minimalistic volcanic landscape with glowing lava flows
  - Azul-Abstract.webp - Material design wallpaper with clean geometric shapes
  - Pueril-Meadow.webp - Peaceful meadow landscape at dawn with morning mist
  - Sea-Bioluminescence.webp - Bioluminescent bay with glowing plankton
  - Each theme now has 3 backgrounds for better slideshow variety

### Changed

- Background wallpaper XML file generation
  - Now generates per-theme XML files instead of a single combined file
  - Creates `celestial-aliz.xml`, `celestial-azul.xml`, `celestial-pueril.xml`, `celestial-sea.xml`
  - Backgrounds are now grouped by theme color in desktop environment pickers
  - Enables slideshow mode with color-coordinated wallpapers
  - XML files are created/removed individually when themes are installed/uninstalled
  - Improves organization and user experience in GNOME, MATE, and Cinnamon

## [1.1.6] - 2025-10-31

### Added

- Cinnamon Transparent panels extension support
  - Panel background gradients now use theme's actual panel color instead of hardcoded black
  - Supports `panel-transparent-with-shadow` and `panel-semi-transparent` modes
  - Gradients automatically match theme color variants (Sea, Aliz, Azul, Pueril)
  - Maintains 40% opacity for semi-transparent effects

## [1.1.5] - 2025-10-28

### Added

- CopyQ clipboard manager theme support with `--copyq` installation flag
  - 8 themes total: 4 color variants (Sea, Aliz, Azul, Pueril) with both dark and light modes
  - Installation to `~/.config/copyq/themes/` (user) or `/usr/share/copyq/themes/` (system-wide)
  - Themes match GTK theme color palette for consistency across applications
  - Comprehensive README with installation instructions and color documentation
  - Themed item lists, tabs, menus, toolbars, and search fields
  - Clean, minimalist design with comfortable contrast ratios
  - Support for theme/color variant filtering with `-t` and `-c` flags
- Slack theme README documentation
  - Added comprehensive README for Slack themes with installation instructions
  - 8 Slack themes: 4 color variants (Aliz, Azul, Pueril, Sea) with both dark and light modes
  - Simple copy-paste installation with theme codes
  - Color breakdown explanation and preview information

## [1.1.4] - 2025-10-27

### Changed

- Enhanced Zed editor themes with color variant support
  - Added four color variants: Sea, Aliz, Azul, and Pueril
  - Each variant now includes both dark and light themes (8 total themes)
  - Updated theme colors to match GTK theme color philosophies:
    - Sea: Cyan/greenish tints (dark) + Cool blue (light)
    - Aliz: Warm pink/red tints (dark) + Pure neutral (light)
    - Azul: Cool blue tints (both modes)
    - Pueril: Pure neutral grays (both modes)
  - Updated installer to support variant-specific installation with `-t` flag
  - Improved README documentation with variant descriptions and examples

## [1.1.3] - 2025-10-26

### Added

- Kitty terminal theme support with `--kitty` installation flag
  - 16-color ANSI palette using Celestial colors
  - Pure black background for OLED friendliness
  - Per-user installation support

## [1.1.2] - 2025-10-25

### Added

- Zed editor theme support with `--zed` installation flag
  - Dark and light theme variants matching Celestial color palette
  - Comprehensive syntax highlighting for all major programming languages
  - Per-user installation support
- Ghostty terminal theme support with `--ghostty` installation flag
  - 16-color ANSI palette using Celestial colors
  - Pure black background for OLED friendliness
  - System-wide and per-user installation support

## [1.1.1] - 2025-10-25

### Changed

- Updated GTKSourceView theme to version 4 format
- Modernized syntax highlighting color palettes to match theme variants

### Removed

- Removed secondary GTKSourceView theme

## [1.1.0] - 2025-10-24

### Added

- Background wallpapers collection for all theme variants
  - Color-coordinated backgrounds for Sea, Aliz, Azul, and Pueril themes
  - High-resolution WebP format backgrounds (QHD+ quality)
  - Minimalistic designs that complement theme aesthetics
  - Automatic integration with GNOME, Cinnamon, and other desktop environments
- `-b, --backgrounds` installation flag for background management
- XML property files for seamless desktop environment integration
- Background installation to user (`~/.local/share/backgrounds/celestial/`) or system-wide (`/usr/share/backgrounds/celestial/`)
- Background removal support with `-b -r` flags
- Comprehensive background documentation in INSTALL.md and backgrounds README.md

## [1.0.4] - 2025-10-22

### Added

- Added full set of Kvantum themes for Qt apps.

## [1.0.3] - 2025-10-14

### Changed

- Fix casing for GTK 3 specialty CSS selectors.

## [1.0.2] - 2025-10-13

### Changed

- Updated gtk3/gtk4 selected levelbar color to actually be visible.

## [1.0.1] - 2025-10-11

### Changed

- Updated Aliz switch enabled state to use sea green.

## [1.0.0] - 2025-10-09

Initial release of Celestial GTK Theme.

### Features

- 12 theme variants (4 colors x 3 modes)
  - **Sea** - Cool cyan tones
  - **Aliz** - Warm crimson hues
  - **Azul** - Deep blue accents
  - **Pueril** - Fresh green tones
  - Each available in Light, Standard, and Dark modes

- Desktop environment support
  - GTK 2, GTK 3, GTK 4
  - GNOME Shell (versions 38, 40, 42, 44, 46, 47, 48)
  - Cinnamon
  - Xfce (Xfwm4 with HiDPI support)
  - Budgie, Pantheon, Unity
  - Openbox

- Dock support
  - [Plank Reloaded](https://github.com/zquestz/plank-reloaded) theming

- Additional features
  - HiDPI and XHiDPI variants for retina displays
  - GDM (login screen) theme support
  - libadwaita app theming
  - GTKSourceView syntax highlighting themes

- Comprehensive documentation
  - Installation guide (INSTALL.md)
  - Development guide (HACKING.md)
  - Asset generation guides in component directories

[1.3.0]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.3.0
[1.2.0]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.2.0
[1.1.9]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.1.9
[1.1.8]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.1.8
[1.1.7]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.1.7
[1.1.6]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.1.6
[1.1.5]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.1.5
[1.1.4]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.1.4
[1.1.3]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.1.3
[1.1.2]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.1.2
[1.1.1]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.1.1
[1.1.0]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.1.0
[1.0.4]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.0.4
[1.0.3]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.0.3
[1.0.2]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.0.2
[1.0.1]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.0.1
[1.0.0]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.0.0
