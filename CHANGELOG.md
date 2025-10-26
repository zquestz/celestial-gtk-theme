# Changelog

All notable changes to the Celestial GTK Theme will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

- 12 theme variants (4 colors × 3 modes)
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

[1.1.1]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.1.1
[1.1.0]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.1.0
[1.0.4]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.0.4
[1.0.3]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.0.3
[1.0.2]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.0.2
[1.0.1]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.0.1
[1.0.0]: https://github.com/zquestz/celestial-gtk-theme/releases/tag/v1.0.0
