# Celestial Tk/ttk Themes

Themes for Tk applications, matching the Celestial GTK theme color variants.

## Overview

These cover applications built with Tk — `gitk`, `git gui`, IDLE, matplotlib's
TkAgg toolbar, and a long tail of scientific and utility software. Unlike the
other extras in this directory, a ttk theme can apply to **every** Tk
application at once, without any per-application configuration, via the
`*TkTheme` X resource.

Both halves of a Tk application are covered:

- **ttk widgets** (`ttk::button`, `ttk::treeview`, …) through `ttk::style`.
- **classic Tk widgets** (`Menu`, `Listbox`, `Text`, `tk::button`), which
  `ttk::style` cannot reach at all, through `tk_setPalette`.

## Available Themes

Eight themes — four colors, each light and dark, named like the other
two-mode extras:

| Color  | Accent    | Light                    | Dark                    |
| ------ | --------- | ------------------------ | ----------------------- |
| Aliz   | `#f0544c` | `celestial-aliz-light`   | `celestial-aliz-dark`   |
| Azul   | `#3498db` | `celestial-azul-light`   | `celestial-azul-dark`   |
| Pueril | `#97bb72` | `celestial-pueril-light` | `celestial-pueril-dark` |
| Sea    | `#2eb398` | `celestial-sea-light`    | `celestial-sea-dark`    |

Celestial's Standard and Light modes differ only in window-manager chrome,
which Tk does not draw, so both use the `-light` theme — a `Celestial-Azul`
desktop uses `celestial-azul-light`.

## Installation

```bash
# Install all eight variants
./install.sh --ttk

# Install specific colors only
./install.sh --ttk -t azul
./install.sh --ttk -t sea -t aliz
```

Installing as root places the themes in `/usr/lib/celestial-ttk`, which Tcl
finds automatically. A per-user install goes to
`~/.local/share/celestial-ttk`, which needs one extra step — see below.

### Per-user installs: TCLLIBPATH

Tcl does not search any directory under `$HOME`, so a per-user install must be
added to `TCLLIBPATH` somewhere the desktop session reads. A shell profile is
not sufficient; applications launched from a menu never source it.

```ini
# ~/.config/environment.d/celestial-ttk.conf
TCLLIBPATH=/home/YOU/.local/share/celestial-ttk
```

Log out and back in for this to take effect.

### Selecting a theme

Tk reads the `TkTheme` X resource at startup and applies it to every
application:

```bash
echo '*TkTheme: celestial-azul-dark' | xrdb -merge -
```

To make it permanent, add the same line to `~/.Xresources`:

```
*TkTheme: celestial-azul-dark
```

Applications pick up the change when they next start.

## Requirements

Tk 8.6 or later, on X11. The `TkTheme` resource is an X11 mechanism; Tk 8.6
has no native Wayland backend and runs under XWayland, where it still works.

## How it works

The themes are built on `clam`, which supplies widget layouts and draws most
widgets acceptably once its 3D bevel is flattened. Four things clam cannot
express in Celestial's language are replaced outright:

- **Check and radio indicators.** clam draws a small bevelled box with an X.
  These use the same PNGs `render-assets.sh` generates for the GTK theme —
  including the mixed artwork for ttk's tristate `alternate` state — so the
  indicators are literally the same artwork.
- **The scale slider.** clam draws it from the root style, which rendered it
  window-background-on-trough — invisible. It now carries GTK's knob colors,
  white in both modes.
- **The notebook tab.** GTK marks the selection with a 2px accent underline
  and no background change; clam's tab bevel can only color the top and left
  edges, so the underline is a small generated image instead.
- **The treeview header divider.** GTK separates header cells with an inset
  1px line down the right edge of each; likewise a generated image.

Header rows otherwise follow GTK: the same background as the table body,
distinguished by a bold font, a muted foreground, and that divider, rather
than a tinted band.

Two GTK details are out of reach without shipping additional artwork, and are
accepted rather than approximated: the scale knob stays rectangular (GTK's is
a circle), and the scale trough has no accent-filled portion below the knob —
ttk draws the trough as a single undivided element. Scrollbar geometry is
likewise clam's — squared slider with stepper arrows — carrying GTK's colors,
including the accent while the slider is dragged.

Some applications also hardcode their own widget colors on top of whatever
theme is active — git-gui's gold diff header and its salmon and green section
titles are the best-known examples. Explicit widget options outrank any
theme, so those survive under this one exactly as they do under every other
dark theme. Menu separators are similar: Tk draws them from shadow colors it
computes internally from the menu background, brightening them sharply on
dark backgrounds, and exposes no option to change them — a quirk shared by
every dark Tk theme.

`celestial.tcl` holds all of the styling. The per-variant files are color
definitions only, so a fix lands once rather than eight times, and they are
generated by `render.sh` from the compiled GTK stylesheets — do not edit them
by hand.

Because Tk has no alpha channel, Celestial's translucent tokens (`borders`,
the insensitive foreground, and the tab hover accent) are pre-composited over
each variant's own background. Those flattened values are recorded in the
header of each variant file.

## gitk

gitk paints its history and diff panes from its own saved preferences rather
than the ttk theme, with light-theme defaults. Paste the block for your
variant into `~/.config/git/gitk` while gitk is closed — it rewrites that
file on exit, and picks the values up on next start.

`selectbgcolor` stays a muted surface rather than the accent: gitk has no
selected-foreground setting, so selected rows keep `fgcolor`, which would not
read on an accent fill. hgk (Mercurial's gitk cousin) manages its colors the
same way, and the same values apply.

#### Aliz Dark

```tcl
set bgcolor #262626
set fgcolor #b5abab
set selectbgcolor #404040
set diffcolors {"#fc4138" "#3498db" "#f0544c"}
set diffbgcolors {"#462a29" "#283741"}
set markbgcolor #404040
set headbgcolor #3498db
set foundbgcolor #f27835
set linkfgcolor #f8aeaa
```

#### Aliz Light

```tcl
set bgcolor #ffffff
set fgcolor #363636
set selectbgcolor #d2d2d2
set diffcolors {"#fc4138" "#3498db" "#f0544c"}
set diffbgcolors {"#ffe3e1" "#e1f0fa"}
set markbgcolor #d2d2d2
set headbgcolor #3498db
set foundbgcolor #f27835
set linkfgcolor #ec271d
```

#### Azul Dark

```tcl
set bgcolor #22252c
set fgcolor #afb4ba
set selectbgcolor #383d49
set diffcolors {"#fc4138" "#2eb398" "#3498db"}
set diffbgcolors {"#43292e" "#243a3c"}
set markbgcolor #383d49
set headbgcolor #2eb398
set foundbgcolor #f27835
set linkfgcolor #8bc4ea
```

#### Azul Light

```tcl
set bgcolor #ffffff
set fgcolor #2e313d
set selectbgcolor #d2d2d2
set diffcolors {"#fc4138" "#2eb398" "#3498db"}
set diffbgcolors {"#ffe3e1" "#e0f4f0"}
set markbgcolor #d2d2d2
set headbgcolor #2eb398
set foundbgcolor #f27835
set linkfgcolor #217dbb
```

#### Pueril Dark

```tcl
set bgcolor #262626
set fgcolor #bababa
set selectbgcolor #404040
set diffcolors {"#fc4138" "#3498db" "#97bb72"}
set diffbgcolors {"#462a29" "#283741"}
set markbgcolor #404040
set headbgcolor #3498db
set foundbgcolor #f27835
set linkfgcolor #cadcb7
```

#### Pueril Light

```tcl
set bgcolor #ffffff
set fgcolor #363636
set selectbgcolor #d2d2d2
set diffcolors {"#fc4138" "#3498db" "#97bb72"}
set diffbgcolors {"#ffe3e1" "#e1f0fa"}
set markbgcolor #d2d2d2
set headbgcolor #3498db
set foundbgcolor #f27835
set linkfgcolor #7ea951
```

#### Sea Dark

```tcl
set bgcolor #222b2e
set fgcolor #abb9b6
set selectbgcolor #38464b
set diffcolors {"#fc4138" "#2eb398" "#2eb398"}
set diffbgcolors {"#432e30" "#243f3e"}
set markbgcolor #38464b
set headbgcolor #2eb398
set foundbgcolor #f27835
set linkfgcolor #6ddac4
```

#### Sea Light

```tcl
set bgcolor #ffffff
set fgcolor #303d41
set selectbgcolor #d2d2d2
set diffcolors {"#fc4138" "#2eb398" "#2eb398"}
set diffbgcolors {"#ffe3e1" "#e0f4f0"}
set markbgcolor #d2d2d2
set headbgcolor #2eb398
set foundbgcolor #f27835
set linkfgcolor #248a76
```

## Development

The variant files and `pkgIndex.tcl` are generated from `src/gtk/`:

```bash
./render.sh
```

Change a palette in `sass/_colors.scss`, run `parse_sass.sh`, then re-run this.
CI regenerates and fails if the committed output is stale.

`gallery.tcl` renders every themed widget in each state, a Treeview, and the
classic Tk widgets, for iterating on the styling:

```bash
wish gallery.tcl                        # default theme
wish gallery.tcl clam                   # a built-in theme, for comparison
wish gallery.tcl celestial-azul-dark    # a Celestial variant
wish gallery.tcl celestial-azul-dark 2  # open on a given tab
```

Run from this directory it reads the indicator assets straight out of
`src/gtk/assets-<color>/`, so no install or copy step is needed. An installed
theme uses the `assets-<variant>` directory beside it instead.
