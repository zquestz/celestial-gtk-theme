# Celestial Firefox Themes

Firefox static themes matching every Celestial GTK theme variant.

## Overview

Each variant is an unpacked WebExtension theme, a single `manifest.json` of
colors generated from the compiled GTK stylesheets. Firefox draws its own
titlebar (the manifest's `frame`), which is where Celestial's Standard and
Light modes differ, so all twelve variants exist here: Standard keeps its
signature dark frame over light content.

The active tab is an accent-filled pill with white text, Celestial's checked
header-button language. Firefox's floating tabs cannot draw a bottom-only
accent line, so the notebook-underline style is not reproducible here.

## Available Themes

| Color  | Accent    | Standard           | Light                    | Dark                    |
| ------ | --------- | ------------------ | ------------------------ | ----------------------- |
| Aliz   | `#f0544c` | `celestial-aliz`   | `celestial-aliz-light`   | `celestial-aliz-dark`   |
| Azul   | `#3498db` | `celestial-azul`   | `celestial-azul-light`   | `celestial-azul-dark`   |
| Pueril | `#97bb72` | `celestial-pueril` | `celestial-pueril-light` | `celestial-pueril-dark` |
| Sea    | `#2eb398` | `celestial-sea`    | `celestial-sea-light`    | `celestial-sea-dark`    |

Each variant is fixed: it does not follow the browser or desktop switching
between light and dark. Pick the one you want and it stays. Every manifest
declares its `color_scheme` so Firefox styles the chrome it does not color
directly to match, rather than guessing from the palette.

## Trying a theme (dev mode)

Regular Firefox only keeps signed themes, but any build can load one
temporarily:

1. Open `about:debugging#/runtime/this-firefox`
2. Click **Load Temporary Add-on**
3. Select the `manifest.json` of your variant

The theme applies immediately and lasts until Firefox restarts. Developer
Edition, Nightly, and ESR can install unsigned add-ons permanently by setting
`xpinstall.signatures.required` to `false` in `about:config`.

## Installing permanently

Mozilla requires themes to be signed by [addons.mozilla.org](https://addons.mozilla.org)
for permanent installation in regular Firefox. See the
[signing and distribution overview](https://extensionworkshop.com/documentation/publish/signing-and-distribution-overview/)
for the process; packing a variant for submission is just zipping it:

```bash
cd celestial-sea-dark && zip -r ../celestial-sea-dark.xpi manifest.json
```

A community-published Sea Dark is already on AMO:
[celestial-sea-dark](https://addons.mozilla.org/firefox/addon/celestial-sea-dark/),
by [@Myhloo](https://github.com/Myhloo), whose work in
[issue #11](https://github.com/zquestz/celestial-gtk-theme/issues/11) started
this component.

## Development

The manifests are generated from `src/gtk/`:

```bash
./render.sh
```

Change a palette in `sass/_colors.scss`, run `parse_sass.sh`, then re-run
this. CI regenerates and fails if the committed output is stale. The theme
`version` in the manifests is bumped by hand when the palettes change, since
AMO versioning is independent of this repo's releases.
