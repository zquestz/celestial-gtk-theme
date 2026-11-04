# Celestial Themes for Telegram Desktop

Themes for [Telegram Desktop](https://desktop.telegram.org/) matching the Celestial GTK theme. Eight themes: 4 color variants (Sea, Aliz, Azul, Pueril) in light and dark.

## Design

- **Neutral message bubbles** - incoming and outgoing bubbles are separated by elevation rather than color, with a hint of the variant's accent in the outgoing bubble so Sea still reads differently from Aliz
- **Accent reserved for controls** - links, send and reply icons, download circles, voice waveforms, unread badges, and the selected chat
- **Flat chat background** - each theme bundles a solid background in the variant's color, because applying colors alone leaves Telegram's patterned default wallpaper behind the messages

## Installation

To install the themes, or only the variant you want, run this from the repository root:

```bash
./install.sh --telegram
./install.sh --telegram -t sea -c dark
```

The themes go in `~/.local/share/celestial/telegram/`, or `/usr/share/celestial/telegram/` for a system-wide install. Like every install flag, this also installs the matching GTK themes, which `-t` and `-c` narrow too.

To apply a theme, open it with Telegram Desktop:

```bash
xdg-open ~/.local/share/celestial/telegram/Celestial-Sea-Dark.tdesktop-theme
```

Double-clicking the file in a file manager or dragging it onto the Telegram window works too. Any copy of the file works, so you don't need the installer. To pick up an updated theme, open the file again. To go back, pick one of Telegram's own themes under **Settings** > **Chat Settings** > **Themes**.

## Files

| File | Variant |
| --- | --- |
| `Celestial-Sea-Light.tdesktop-theme` | Sea (Teal), light |
| `Celestial-Sea-Dark.tdesktop-theme` | Sea (Teal), dark |
| `Celestial-Aliz-Light.tdesktop-theme` | Aliz (Coral red), light |
| `Celestial-Aliz-Dark.tdesktop-theme` | Aliz (Coral red), dark |
| `Celestial-Azul-Light.tdesktop-theme` | Azul (Blue), light |
| `Celestial-Azul-Dark.tdesktop-theme` | Azul (Blue), dark |
| `Celestial-Pueril-Light.tdesktop-theme` | Pueril (Green), light |
| `Celestial-Pueril-Dark.tdesktop-theme` | Pueril (Green), dark |

## Development

The themes are generated - do not edit them by hand:

```bash
./src/extra/telegram/render.sh
```

Each `.tdesktop-theme` is a zip holding the generated palette and a flat background image. `base/` holds Telegram's own theme-authoring bases (`day-custom-base` and `night-custom-base` from [tdesktop](https://github.com/telegramdesktop/tdesktop), unmodified). The generator compiles the GTK sass palette per variant and applies the override table in `render.sh` on top of the matching base, so anything Celestial does not theme - group member colors, file type colors, call buttons - keeps the value Telegram designed for that mode.

## Credits

Based on the theme-authoring bases from [Telegram Desktop](https://github.com/telegramdesktop/tdesktop) by Telegram Messenger LLP.
