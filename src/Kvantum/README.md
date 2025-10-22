# Kvantum Qt Theme

This directory contains Kvantum theme files for Qt applications.

## Why Include a Qt Theme?

While Celestial is primarily a GTK theme, many users run Qt applications (like VLC, Telegram, KDE apps, etc.) within GTK-based desktop environments such as GNOME, Cinnamon, XFCE, and MATE.

Without proper Qt theming, these applications would look out of place - using different colors, styling, and visual language than the rest of the desktop. This creates a jarring, inconsistent user experience.

By including Kvantum theme files, we ensure that Qt applications seamlessly integrate with your GTK environment, providing:

- **Visual Consistency** - Qt apps match your GTK theme colors and accent
- **Unified Experience** - All applications feel like they belong together
- **Professional Appearance** - No mismatched styling or jarring color differences

## What is Kvantum?

[Kvantum](https://github.com/tsujan/Kvantum) is a powerful SVG-based theme engine for Qt applications. It allows Qt apps to use custom themes that can closely match GTK styling, making it the ideal solution for Qt theming in GTK environments.

## Installation

Kvantum themes can be optionally installed using the `-k` or `--kvantum` flag with the main install script:

```bash
./install.sh --kvantum
```

This will install Kvantum themes to:

- User installation: `~/.config/Kvantum/`
- System installation: `/usr/share/Kvantum/` (when run with sudo)

After installation, use the **Kvantum Manager** application to select your Celestial theme variant.

## Theme Variants

Celestial provides Kvantum themes for all variants:

- **Sea** (Teal) - Light, Standard, and Dark
- **Aliz** (Crimson) - Light, Standard, and Dark
- **Azul** (Blue) - Light, Standard, and Dark
- **Pueril** (Green) - Light, Standard, and Dark

## Alternative Qt Theming Tools

If you prefer a different approach to Qt theming, you can also consider:

- **[qt6gtk2](https://github.com/trialuser02/qt6gtk2)** - Qt6 style plugin using GTK2 rendering
- **[Qt Style Plugins](https://github.com/qt/qtstyleplugins)** - Qt5 style plugins including GTK2 support

These tools provide alternative Qt theming approaches that can be used instead of Kvantum.

## Credits

The Kvantum theme structure is based on [Matcha-kde](https://github.com/vinceliuice/Matcha-kde) by Vince Liuice, adapted for the Celestial.
