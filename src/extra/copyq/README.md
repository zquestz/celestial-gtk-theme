# Celestial Themes for CopyQ

Custom CopyQ themes matching the Celestial GTK theme color palette.

## Available Themes

Celestial provides 8 CopyQ themes - 4 color variants, each with dark and light modes:

- **Aliz** - Warm red/crimson tones
- **Azul** - Cool blue tones
- **Pueril** - Fresh green tones
- **Sea** - Cool cyan/teal tones

## Installation

### Method 1: Using the Installer (Recommended)

Install all CopyQ themes:

```bash
./install.sh --copyq
```

Install specific variant(s):

```bash
./install.sh --copyq -t azul
./install.sh --copyq -t sea -c dark
```

Then in CopyQ:

1. Go to **File** > **Preferences** (or press `Ctrl+P`)
2. Navigate to the **Appearance** tab
3. Select your desired Celestial theme from the **Theme** dropdown menu
4. Click **OK** to apply

### Method 2: Manual Installation

1. Copy the desired theme file to CopyQ's themes directory:

   ```bash
   # For user installation (recommended)
   mkdir -p ~/.config/copyq/themes
   cp celestial-<theme>-<color>.ini ~/.config/copyq/themes/

   # For system-wide installation (requires root)
   sudo mkdir -p /usr/share/copyq/themes
   sudo cp celestial-<theme>-<color>.ini /usr/share/copyq/themes/
   ```

2. Open CopyQ

3. Go to **File** > **Preferences** (or press `Ctrl+P`)

4. Navigate to the **Appearance** tab

5. Select your desired Celestial theme from the **Theme** dropdown menu

6. Click **OK** to apply the theme

### Method 3: Import Theme

1. Open CopyQ

2. Go to **File** > **Preferences** > **Appearance** tab

3. Click **Load Theme** button (this is for importing new theme files)

4. Navigate to the location where you downloaded the theme files

5. Select a Celestial theme file (e.g., `celestial-azul-dark.ini`)

6. Click **Open** to import the theme

7. The theme will now appear in the **Theme** dropdown menu

8. Click **OK** to apply

## Theme Files

### Dark Themes

- `celestial-aliz-dark.ini` - Red/crimson accent on dark background
- `celestial-azul-dark.ini` - Blue accent on cool dark background
- `celestial-pueril-dark.ini` - Green accent on dark background
- `celestial-sea-dark.ini` - Cyan/teal accent on cool dark background

### Light Themes

- `celestial-aliz-light.ini` - Red/crimson accent on light background
- `celestial-azul-light.ini` - Blue accent on light background
- `celestial-pueril-light.ini` - Green accent on light background
- `celestial-sea-light.ini` - Cyan/teal accent on light background

## Color Palette

Each theme uses colors that match the corresponding Celestial GTK theme variant:

| Variant    | Accent Color | Description                  |
| ---------- | ------------ | ---------------------------- |
| **Aliz**   | `#f0544c`    | Red/crimson - warm red tones |
| **Azul**   | `#3498db`    | Blue - cool blue tones       |
| **Pueril** | `#97bb72`    | Green - fresh green tones    |
| **Sea**    | `#2eb398`    | Cyan/teal - cool ocean tones |

### Dark Theme Colors

**Aliz & Pueril (Neutral Dark)**

- **Background**: Neutral dark gray (#222222)
- **Foreground**: Light gray (#d8d8d8)
- **Selection**: Variant accent color with white text
- **Alt Background**: Slightly lighter gray (#2d2d30)

**Azul & Sea (Cool Dark)**

- **Background**: Cool dark gray (#1b1d24 for Azul, #1b2224 for Sea)
- **Foreground**: Light gray (#d8d8d8)
- **Selection**: Variant accent color with white text
- **Alt Background**: Slightly lighter cool gray

### Light Theme Colors

**All Variants**

- **Background**: Off-white (#f7f7f7)
- **Foreground**: Dark gray (#2d2d2d)
- **Selection**: Variant accent color with white text
- **Alt Background**: Light gray (#eeeeee)

## Theme Directory Locations

CopyQ looks for themes in the following locations:

- **User themes**: `~/.config/copyq/themes/` (recommended for personal customization)
- **System themes**: `/usr/share/copyq/themes/` (requires root access)

User themes take precedence over system themes if both exist.

## Customization

You can further customize the themes by editing the `.ini` files. Key settings include:

- `bg` - Main background color
- `fg` - Main foreground (text) color
- `sel_bg` - Selection background color
- `sel_fg` - Selection foreground color
- `alt_bg` - Alternative background color
- `theme_color` - Theme accent color

For more information on CopyQ theme customization, see the [CopyQ documentation](https://copyq.readthedocs.io/en/latest/theme.html).

## Features

- Clean, minimalist design matching Celestial GTK themes
- Comfortable contrast ratios for extended use
- Consistent color scheme with other Celestial theme components (Zed, Slack, terminal themes)
- Subtle visual hierarchy with well-defined selection states
- Optimized for readability
