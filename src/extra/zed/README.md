# Celestial Themes for Zed Editor

Dark and light themes for [Zed](https://zed.dev/) in four color variants that match the Celestial GTK theme palette.

## Theme Variants

Celestial provides four color variants, each with dark and light appearances:

- **Celestial Sea** - Cool cyan tones
- **Celestial Aliz** - Warm crimson hues
- **Celestial Azul** - Deep blue accents
- **Celestial Pueril** - Fresh green tones

Each variant includes both **Dark** and **Light** themes (8 themes total).

## Color Palette

The Celestial Zed themes use a carefully crafted color palette for optimal code readability:

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

### Using the Installer Script

The easiest way to install is using the Celestial installer:

```bash
# Install all color variants
./install.sh --zed

# Install specific color variant(s)
./install.sh --zed -t azul
./install.sh --zed -t sea -t aliz
```

**Note:** Zed themes can only be installed for user accounts (not system-wide).

### Manual Installation

1. Copy the theme files to your Zed themes directory:

   **Linux:**

   ```bash
   mkdir -p ~/.config/zed/themes
   cp celestial-*.json ~/.config/zed/themes/
   ```

   **macOS:**

   ```bash
   mkdir -p ~/Library/Application\ Support/Zed/themes
   cp celestial-*.json ~/Library/Application\ Support/Zed/themes/
   ```

2. Open Zed and select your theme from the theme selector (Cmd+K Cmd+T or Ctrl+K Ctrl+T)

3. Choose from:
   - Celestial Sea Dark / Light
   - Celestial Aliz Dark / Light
   - Celestial Azul Dark / Light
   - Celestial Pueril Dark / Light

## Features

- **Four Color Variants**: Sea, Aliz, Azul, and Pueril themes
- **Dark and Light Modes**: Each variant includes both appearances
- **Consistent UI Colors**: UI grays match the corresponding GTK theme variant
- **Unified Syntax Colors**: Syntax highlighting consistent across all variants
- **Terminal Integration**: ANSI colors match Ghostty/Kitty terminal themes
- **Optimized Readability**: Carefully chosen colors for long coding sessions
- **Comprehensive Coverage**: Supports all major programming languages

## Uninstalling

Remove installed themes:

```bash
# Remove all variants
./install.sh --zed -r

# Remove specific variant(s)
./install.sh --zed -r -t azul
```

## Customization

You can customize any theme variant by editing the JSON files directly. The themes follow Zed's theme schema v0.2.0.

For more information on creating and customizing Zed themes, see:

- [Zed Theme Documentation](https://zed.dev/docs/themes)
- [Zed Theme Gallery](https://zed-themes.com/)
