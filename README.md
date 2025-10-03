# Celestial GTK Theme

![Version](https://img.shields.io/badge/Version-1.0.0-blue?style=flat-square) ![License](https://img.shields.io/badge/License-GPL%20v3-blue?style=flat-square) ![GTK Version](https://img.shields.io/badge/GTK-3%20%7C%204-blue?style=flat-square) ![GNOME Shell](https://img.shields.io/badge/GNOME%20Shell-38%20--%2048-blue?style=flat-square)

**A modern, customizable GTK theme with multiple color variants**

Based on the excellent [Arc](https://github.com/horst3180/Arc-theme) and [Matcha](https://github.com/vinceliuice/Matcha-gtk-theme) themes

**[Changelog](CHANGELOG.md)** • **[Installation Guide](INSTALL.md)** • **[Development Guide](HACKING.md)**

## Features

- **12 Theme Variants** - 4 colors (Sea, Aliz, Azul, Pueril) × 3 modes (Light, Standard, Dark)
- **Desktop Support** - GTK 2/3/4, GNOME Shell (38-48), Cinnamon, XFCE, Budgie, Pantheon, Unity, Openbox
- **Dock Support** - [Plank Reloaded](https://github.com/zquestz/plank-reloaded) theming
- **HiDPI Support** - Standard, HiDPI, and XHiDPI variants for retina displays
- **Additional Theming** - GDM login screen, libadwaita apps, GTKSourceView syntax highlighting

## Installation

For complete installation instructions, requirements, and customization options, see **[INSTALL.md](INSTALL.md)**.

### Quick Start

```bash
git clone https://github.com/zquestz/celestial-gtk-theme.git
cd celestial-gtk-theme
./install.sh
```

This installs all theme variants to `~/.themes/`. For system-wide installation, customization options, and applying the theme to your desktop, see the full [installation guide](INSTALL.md).

## Recommended Companions

Complete your desktop with these complementary themes:

- **[Papirus Icon Theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)** - Modern icon theme with excellent coverage
- **[WhiteSur Cursors](https://github.com/vinceliuice/WhiteSur-cursors)** - Elegant cursor theme
- **[Hardcode-Tray](https://github.com/bilelmoussaoui/Hardcode-Tray)** - Fix hardcoded tray icons
- **[Folder Color](https://github.com/costales/folder-color)** - Change folder colors in Nautilus, Nemo, and Caja

## Development

### Building from Source

If you modify SCSS files, rebuild the CSS:

```bash
./parse_sass.sh
```

This will regenerate all CSS files from SCSS sources.

## Troubleshooting

For troubleshooting common issues, see the [Troubleshooting section in INSTALL.md](INSTALL.md#troubleshooting).

## Contributing

Contributions are welcome! For development guidelines and detailed instructions, see [HACKING.md](HACKING.md).

**Quick Start:**

1. Fork and create a feature branch
2. Edit SCSS files in `src/*/sass/` directories
3. Compile with `./parse_sass.sh`
4. Test with `./install.sh -t sea -c dark`
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
