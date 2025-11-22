# Installation Guide

This guide covers installation, customization, and application of the Celestial GTK Theme.

## Requirements

### Required Dependencies

- `gtk-murrine-engine` (GTK2 engine)
- `gtk2-engines-pixbuf` or `gtk-engines`

### Optional Dependencies

- `sassc` - For building from source
- `inkscape` - For rendering theme assets
- `optipng` - For optimizing PNG assets

## Installing Dependencies

**Fedora/RHEL:**

```bash
sudo dnf install gtk-murrine-engine gtk2-engines
```

**Ubuntu/Debian/Mint:**

```bash
sudo apt install gtk2-engines-murrine gtk2-engines-pixbuf
```

**Arch Linux:**

```bash
sudo pacman -S gtk-engine-murrine gtk-engines
```

**Solus:**

```bash
sudo eopkg it gtk2-engine-murrine gtk-engines
```

## Quick Install

1. **Clone the repository:**

```bash
git clone https://github.com/zquestz/celestial-gtk-theme.git
cd celestial-gtk-theme
```

2. **Run the installer:**

```bash
./install.sh
```

This will install all theme variants to `~/.themes/` (user) or `/usr/share/themes/` (system-wide if run with sudo).

## Customization Options

The install script provides extensive customization options:

```bash
./install.sh [OPTIONS...]
```

### Available Options

| Option                 | Description                                                      |
| ---------------------- | ---------------------------------------------------------------- |
| `-d, --dest DIR`       | Destination directory (Default: `/home/USER/.themes`)            |
| `-n, --name NAME`      | Theme name (Default: `Celestial`)                                |
| `-c, --color VARIANTS` | Color variant [standard\|light\|dark] (Default: All)             |
| `-t, --theme VARIANTS` | Theme variant [sea\|aliz\|azul\|pueril] (Default: All)           |
| `-s, --gnome-shell`    | GNOME Shell version [38\|40\|42\|44\|46\|47\|48] (Default: Auto) |
| `-l, --libadwaita`     | Link libadwaita apps to GTK-4.0 theme                            |
| `-k, --kvantum`        | Install Kvantum theme for Qt applications                        |
| `-b, --backgrounds`    | Install theme backgrounds                                        |
| `--copyq`              | Install CopyQ clipboard manager themes                           |
| `--cursors`            | Install Celestial cursor theme                                   |
| `--ghostty`            | Install Ghostty terminal theme                                   |
| `--halloy`             | Install Halloy IRC client themes                                 |
| `--kitty`              | Install Kitty terminal theme                                     |
| `--zed`                | Install Zed editor themes                                        |
| `-g, --gdm`            | Install GDM theme (requires sudo)                                |
| `-r, --remove`         | Uninstall theme                                                  |
| `-h, --help`           | Show this help                                                   |

### Installation Examples

**Install specific color and theme:**

```bash
./install.sh -t azul -c dark
```

**Install all azul variants:**

```bash
./install.sh -t azul
```

**Install for specific GNOME Shell version:**

```bash
./install.sh -s 48
```

**Install to custom directory:**

```bash
./install.sh -d ~/.local/share/themes
```

**Install GDM theme (requires root):**

```bash
sudo ./install.sh -g -t azul -c dark
```

**Install with libadwaita support:**

```bash
./install.sh -l -t azul -c dark
```

**Install with Kvantum Qt theme support:**

```bash
./install.sh -k -t azul -c dark
```

**Install all variants with Kvantum:**

```bash
./install.sh -k
```

**Install theme backgrounds:**

```bash
./install.sh -b
```

**Install specific theme backgrounds:**

```bash
./install.sh -b -t azul
```

**Install CopyQ clipboard manager themes:**

```bash
./install.sh --copyq
```

**Install Ghostty terminal theme:**

```bash
./install.sh --ghostty
```

**Install Kitty terminal theme:**

```bash
./install.sh --kitty
```

**Install Zed editor themes:**

```bash
./install.sh --zed
```

**Install Halloy IRC client themes:**

```bash
./install.sh --halloy
```

**Install cursor theme:**

```bash
./install.sh --cursors
```

**Install everything (theme + backgrounds + Kvantum + CopyQ + cursors + Ghostty + Halloy + Kitty + Zed):**

```bash
./install.sh -k -b --copyq --cursors --ghostty --halloy --kitty --zed
```

## Uninstalling

Remove installed themes:

```bash
./install.sh -r
```

Remove specific variant:

```bash
./install.sh -r -t azul -c dark
```

Remove GDM theme:

```bash
sudo ./install.sh -g -r
```

Remove backgrounds:

```bash
./install.sh -b -r
```

Remove specific theme backgrounds:

```bash
./install.sh -b -r -t azul
```

Remove Kvantum themes:

```bash
./install.sh -k -r
```

**Remove CopyQ clipboard manager themes:**

```bash
./install.sh --copyq -r
```

**Remove cursor theme:**

```bash
./install.sh --cursors -r
```

**Remove Ghostty terminal theme:**

```bash
./install.sh --ghostty -r
```

**Remove Halloy IRC client themes:**

```bash
./install.sh --halloy -r
```

**Remove Kitty terminal theme:**

```bash
./install.sh --kitty -r
```

**Remove Zed editor themes:**

```bash
./install.sh --zed -r
```

## Applying the Theme

### GNOME Desktop

Using GNOME Tweaks:

```bash
gnome-tweaks
```

Go to **Appearance** and select your desired **Celestial** variant

Or via command line:

```bash
gsettings set org.gnome.desktop.interface gtk-theme "Celestial-Azul-Dark"
gsettings set org.gnome.desktop.wm.preferences theme "Celestial-Azul-Dark"
```

### Xfce Desktop

```bash
xfconf-query -c xsettings -p /Net/ThemeName -s "Celestial-Azul-Dark"
xfconf-query -c xfwm4 -p /general/theme -s "Celestial-Azul-Dark"
```

### Cinnamon Desktop

Open **System Settings** then **Themes** and select your Celestial variant

### Flatpak Applications

To theme Flatpak apps, run:

```bash
sudo flatpak override --filesystem=~/.themes
```

Or for system-wide themes:

```bash
sudo flatpak override --filesystem=/usr/share/themes
```

## Troubleshooting

### Theme Not Showing Up

1. Make sure you've installed to the correct directory:
   - User themes: `~/.themes/`
   - System themes: `/usr/share/themes/`

2. Restart your session or reload the theme manager

3. Check that all dependencies are installed

### Flatpak Apps Not Themed

Run the flatpak override commands mentioned in the Applying the Theme section.

### libadwaita Apps Not Themed

GNOME 43+ uses libadwaita which doesn't support custom themes by default. Use the `-l` flag:

```bash
./install.sh -l -t azul -c dark
```

Note: This will apply the theme to all GTK4 apps and cannot be easily switched.

## Advanced Installation

### Building from Source

If you want to modify the theme, you can rebuild it from source.

1. Install build dependencies:

```bash
# Fedora/RHEL
sudo dnf install sassc inkscape optipng

# Ubuntu/Debian
sudo apt install sassc inkscape optipng

# Arch Linux
sudo pacman -S sassc inkscape optipng
```

2. Modify SCSS files in `src/*/sass/` directories

3. Compile the theme:

```bash
./parse_sass.sh
```

4. Install your modified theme:

```bash
./install.sh
```

### System-Wide Installation

To install for all users:

```bash
sudo ./install.sh
```

This will install to `/usr/share/themes/` instead of `~/.themes/`

### Custom Theme Name

If you want to install with a different name (useful for testing):

```bash
./install.sh -n MyCustomTheme -t azul -c dark
```

This will create `MyCustomTheme-azul-dark` in your themes directory.

## Background Wallpapers

Celestial includes a collection of color-coordinated background wallpapers for each theme variant.

### Installing Backgrounds

Install backgrounds for all themes:

```bash
./install.sh -b
```

Install backgrounds for specific theme:

```bash
./install.sh -b -t azul
```

Backgrounds will be installed to:

- User install: `~/.local/share/backgrounds/celestial/`
- System-wide install (with sudo): `/usr/share/backgrounds/celestial/`

### Using Backgrounds

After installation, backgrounds will appear in your desktop environment's wallpaper/background settings:

- **GNOME**: Settings → Background
- **Xfce**: Settings Manager → Desktop → Background
- **Cinnamon**: System Settings → Backgrounds
- **MATE**: System Settings → Appearance → Background

Backgrounds are grouped by theme color (e.g., "Azul Space" and "Azul Ice" appear together). This allows you to use slideshow mode to automatically rotate through color-coordinated wallpapers!

### Desktop Environment Integration

The installer creates theme-specific XML property files:

- `gnome-background-properties/celestial-aliz.xml`
- `gnome-background-properties/celestial-azul.xml`
- `gnome-background-properties/celestial-pueril.xml`
- `gnome-background-properties/celestial-sea.xml`

(Similar files are created for MATE and Cinnamon in their respective directories)

Each XML file contains only the wallpapers for that specific theme color, making it easy to enable slideshow mode for a consistent color palette.

### Uninstalling Backgrounds

Remove all installed backgrounds:

```bash
./install.sh -b -r
```

Remove specific theme backgrounds:

```bash
./install.sh -b -r -t azul
```
