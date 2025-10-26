# Celestial Theme for Zed Editor

A dark and light theme for [Zed](https://zed.dev/) that matches the Celestial GTK theme color palette.

## Color Palette

The Celestial Zed theme uses a carefully crafted color palette for optimal code readability:

- **Comments** - `#7e8e8c` - Muted gray-green for subtle comments
- **Text** - `#cfdcd8` (dark) / `#2e3436` (light) - Clear, readable default text
- **Classes/Types** - `#1ecca9` - Bright cyan for class names and types
- **Functions** - `#f0544c` - Aliz red for function definitions and calls
- **Keywords** - `#3498db` - Blue for language keywords and operators
- **Strings** - `#2eb398` - Teal for string literals
- **Numbers** - `#c678dd` - Purple for numeric values
- **Preprocessor** - `#42A5F5` - Light blue for preprocessor directives
- **Annotations** - `#F39C12` - Orange for annotations and escape sequences
- **Errors** - `#e74c3c` - Red for errors and regex patterns

## Installation

### Manual Installation

1. Copy `celestial.json` to your Zed themes directory:

   **Linux:**

   ```bash
   mkdir -p ~/.config/zed/themes
   cp celestial.json ~/.config/zed/themes/
   ```

   **macOS:**

   ```bash
   mkdir -p ~/Library/Application\ Support/Zed/themes
   cp celestial.json ~/Library/Application\ Support/Zed/themes/
   ```

   **Windows:**

   ```powershell
   mkdir -p $env:APPDATA\Zed\themes
   copy celestial.json $env:APPDATA\Zed\themes\
   ```

2. Open Zed and go to Settings (Cmd+, or Ctrl+,)

3. Search for "theme" in settings

4. Select either "Celestial Dark" or "Celestial Light"

### Using Zed's Theme Selector

1. Open the command palette (Cmd+Shift+P or Ctrl+Shift+P)
2. Type "theme selector"
3. Choose "Celestial Dark" or "Celestial Light"

## Features

- **Two Variants**: Dark and Light themes to match your preference
- **Consistent Colors**: Matches the Celestial GTK theme palette
- **Optimized Readability**: Carefully chosen colors for long coding sessions
- **Comprehensive Coverage**: Supports all major programming languages

## Screenshots

### Dark Theme

The dark theme provides excellent contrast with a dark background perfect for low-light environments.

### Light Theme

The light theme offers a clean, bright appearance ideal for well-lit spaces.

## Customization

You can customize the theme by editing `celestial.json` directly. The theme follows Zed's theme schema v0.2.0.

For more information on creating and customizing Zed themes, see:

- [Zed Theme Documentation](https://zed.dev/docs/themes)
- [Zed Theme Gallery](https://zed-themes.com/)

## Compatibility

- **Zed Version**: Compatible with Zed theme schema v0.2.0+
- **Platforms**: Linux, macOS, Windows

## Related

This theme is part of the [Celestial GTK Theme](https://github.com/zquestz/celestial-gtk-theme) project, which includes:

- GTK 2/3/4 themes
- GNOME Shell themes
- GTKSourceView themes
- Kvantum Qt themes
- Zed editor themes

## Support

For issues, suggestions, or contributions, please visit the [Celestial GTK Theme repository](https://github.com/zquestz/celestial-gtk-theme).

## License

This theme is part of the Celestial GTK Theme project and is licensed under the GNU General Public License v3.0.
