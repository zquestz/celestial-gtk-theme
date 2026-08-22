#
# Celestial ttk themes - shared implementation.
#
# The per-variant files in this directory are colour definitions only; all of
# the widget styling lives here so a fix lands once rather than eight times.
#
# Built on clam, which supplies layouts and the widgets it draws acceptably.
# Four things clam cannot do in Celestial's language are replaced outright:
#
#   - check and radio indicators, which clam draws as a small bevelled box
#     with an X. These use the PNGs render-assets.sh already generates for
#     GTK - including the mixed/tristate artwork for ttk's alternate state -
#     so the indicators are literally the same artwork.
#   - the scale slider, which clam draws from the root style and so rendered
#     window-background-on-trough, i.e. invisible. It now carries GTK's knob
#     colours (white in both modes), though it stays rectangular: a round
#     knob is not reachable without shipping more artwork.
#   - the notebook tab, where GTK marks the selection with a 2px accent
#     underline ("box-shadow: inset 0 -2px <accent>") and no background
#     change. clam's tab bevel can only colour the top and left edges, so the
#     underline is a small generated image stretched by its element border.
#   - the treeview header divider, GTK's inset 1px line down the right edge
#     of each header cell, likewise a generated image.
#
# Tk has no alpha, so the translucent GTK tokens arrive here pre-composited
# over each variant's own background. See the per-variant files.
#

package require Tk 8.6
package provide celestial::ttk 1.0

namespace eval ::celestial::ttk {

  # Indicator asset basenames. The variant supplies the suffix: "-dark" for
  # dark themes, empty for light ones.
  variable indicators {
    cb-off      checkbox-unchecked
    cb-on       checkbox-checked
    cb-mix      checkbox-mixed
    cb-off-dis  checkbox-unchecked-insensitive
    cb-on-dis   checkbox-checked-insensitive
    cb-mix-dis  checkbox-mixed-insensitive
    rb-off      radio-unchecked
    rb-on       radio-checked
    rb-mix      radio-mixed
    rb-off-dis  radio-unchecked-insensitive
    rb-on-dis   radio-checked-insensitive
    rb-mix-dis  radio-mixed-insensitive
  }

  # Two layouts resolve. Installed, the PNGs sit beside the theme so the
  # package directory is self-contained and relocatable. In-tree they are read
  # straight from the GTK asset directory, so development needs no copy step
  # and the files cannot drift from the originals.
  proc assetdir {scriptdir variant gtkcolor} {
    foreach candidate [list \
        [file join $scriptdir assets-$variant] \
        [file normalize [file join $scriptdir .. .. gtk assets-$gtkcolor]]] {
      if {[file isdirectory $candidate]} {
        return $candidate
      }
    }
    return ""
  }

  # Returns a key -> image dict, or empty if any asset is missing. All twelve
  # or none, so a partial set falls back to clam rather than rendering half
  # the indicators as images and half as bevelled boxes.
  proc loadindicators {dir suffix} {
    variable indicators
    if {$dir eq ""} {
      return {}
    }
    set out [dict create]
    foreach {key base} $indicators {
      set path [file join $dir ${base}${suffix}.png]
      if {![file readable $path]} {
        return {}
      }
      dict set out $key [image create photo -file $path]
    }
    return $out
  }

  # A flat fill with an accent strip along the bottom. The element border
  # pins the strip while the middle stretches, giving a full-width underline
  # at whatever size the tab ends up.
  proc tabimage {bg accent} {
    set im [image create photo -width 8 -height 24]
    $im put $bg -to 0 0 8 24
    $im put $accent -to 0 22 8 24
    return $im
  }

  # Scale knob: GTK's is white in both modes with a dark ring. Drawn as an
  # image because clam shares -background between the slider and the widget
  # face, so colouring the slider white would halo the whole trough.
  proc knobimage {fill border} {
    set im [image create photo -width 16 -height 16]
    $im put $border -to 0 0 16 16
    $im put $fill -to 1 1 15 15
    return $im
  }

  # Treeview header cell: a flat fill with a 1px divider down the right edge,
  # inset vertically rather than running edge to edge. This is GTK's
  # "border-style: none solid none none" with its 20%-80% border-image
  # gradient, and it is what makes the header read as a header given that the
  # background matches the table body.
  proc headingimage {bg line} {
    set im [image create photo -width 8 -height 24]
    $im put $bg -to 0 0 8 24
    $im put $line -to 7 5 8 19
    return $im
  }

  # Classic Tk widgets (Menu, Listbox, Text, tk::Button) are outside
  # ttk::style entirely. The global *TkTheme path only sources a variant when
  # that theme is selected, so setting the palette here scopes it correctly.
  proc setpalette {colors} {
    catch {
      tk_setPalette \
        background [dict get $colors -bg] \
        foreground [dict get $colors -fg] \
        activeBackground [dict get $colors -active] \
        activeForeground [dict get $colors -fg] \
        selectBackground [dict get $colors -selectbg] \
        selectForeground [dict get $colors -selectfg] \
        highlightBackground [dict get $colors -bg] \
        highlightColor [dict get $colors -selectbg] \
        insertBackground [dict get $colors -fg] \
        troughColor [dict get $colors -trough] \
        disabledForeground [dict get $colors -disabledfg]
    }
    # GTK menus highlight with the accent, unlike other classic widgets whose
    # hover stays neutral. A more specific pattern than tk_setPalette's
    # *activeBackground covers just menus.
    option add *Menu.activeBackground [dict get $colors -selectbg] widgetDefault
    option add *Menu.activeForeground [dict get $colors -selectfg] widgetDefault
    option add *Menu.activeBorderWidth 0 widgetDefault
    # Menus default to a raised 3D bevel, and Tk brightens the highlight
    # aggressively on near-black backgrounds - a white line over every
    # menubar. Solid keeps a 1px outline so dropdown menus (same widget
    # class) do not float borderless over a dark window.
    option add *Menu.relief solid widgetDefault
    option add *Menu.borderWidth 1 widgetDefault
    option add *tearOff 0
  }

  #
  # Build a theme.
  #
  #   name      ttk theme name, e.g. celestial-azul-dark
  #   scriptdir directory of the calling variant file
  #   opts      -variant  asset directory suffix, e.g. azul-dark
  #             -gtkcolor in-tree GTK asset colour, e.g. azul
  #             -suffix   asset filename suffix, "-dark" or ""
  #             -colors   flat key/value list of the palette
  #
  proc create {name scriptdir args} {
    variable C
    variable I
    variable T

    array set opt {-variant "" -gtkcolor "" -suffix "" -colors {}}
    array set opt $args

    # Already created in this interpreter - typically auto-loaded through
    # *TkTheme from an installed copy before a local file is sourced.
    # ttk themes cannot be redefined, so refresh the palette and stop rather
    # than erroring out of the caller's source.
    if {[lsearch -exact [ttk::style theme names] $name] >= 0} {
      setpalette $opt(-colors)
      return
    }

    # Staged in the namespace so the -settings script can reach them by
    # fully-qualified upvar regardless of the scope ttk evaluates it in.
    # Creation is synchronous, so later themes overwriting these is harmless:
    # element definitions capture image names, not the arrays.
    array unset C
    array set C $opt(-colors)

    set dir [assetdir $scriptdir $opt(-variant) $opt(-gtkcolor)]
    set images [loadindicators $dir $opt(-suffix)]

    array unset I
    if {[dict size $images]} {
      array set I $images
      set C(useimages) 1
    } else {
      set C(useimages) 0
    }

    array unset T
    set T(normal)   [tabimage $C(-bg) $C(-bg)]
    set T(active)   [tabimage $C(-bg) $C(-tabhover)]
    set T(selected) [tabimage $C(-bg) $C(-primary)]
    set T(heading)  [headingimage $C(-inputbg) $C(-headingline)]
    set T(knob)     [knobimage $C(-scaleslider) $C(-border)]
    set T(knob-dis) [knobimage $C(-disabledbg) $C(-border)]

    ttk::style theme create $name -parent clam -settings {
      upvar #0 ::celestial::ttk::C c
      upvar #0 ::celestial::ttk::I i
      upvar #0 ::celestial::ttk::T t

      # ---------------------------------------------------------------- base
      # Collapsing clam's lightcolor/darkcolor onto bordercolor is what turns
      # its 3D bevel into Celestial's flat 1px outline.
      ttk::style configure . \
        -background $c(-bg) \
        -foreground $c(-fg) \
        -troughcolor $c(-trough) \
        -bordercolor $c(-border) \
        -darkcolor $c(-border) \
        -lightcolor $c(-border) \
        -fieldbackground $c(-inputbg) \
        -selectbackground $c(-selectbg) \
        -selectforeground $c(-selectfg) \
        -insertcolor $c(-fg) \
        -arrowcolor $c(-fg) \
        -focuscolor $c(-selectbg) \
        -insertwidth 1 \
        -borderwidth 1 \
        -relief flat

      ttk::style map . \
        -background [list disabled $c(-bg)] \
        -foreground [list disabled $c(-disabledfg)] \
        -selectbackground [list !focus $c(-selectbg)] \
        -selectforeground [list !focus $c(-selectfg)]

      # ------------------------------------------------------------- buttons
      ttk::style configure TButton \
        -background $c(-button) \
        -foreground $c(-fg) \
        -padding {10 5} \
        -anchor center

      # GTK's pressed button is accent-filled with white text, not a darker
      # grey - pressing any Celestial button flashes the accent.
      ttk::style map TButton \
        -background [list disabled $c(-disabledbg) \
                          pressed $c(-primary) \
                          active $c(-active)] \
        -foreground [list disabled $c(-disabledfg) \
                          pressed $c(-selectfg)] \
        -bordercolor [list focus $c(-selectbg)] \
        -lightcolor [list pressed $c(-primary)] \
        -darkcolor [list pressed $c(-primary)]

      ttk::style configure Accent.TButton \
        -background $c(-primary) \
        -foreground $c(-selectfg)

      # GTK's suggested-action lightens on hover.
      ttk::style map Accent.TButton \
        -background [list disabled $c(-disabledbg) \
                          pressed $c(-primary) \
                          active $c(-accenthover)] \
        -foreground [list disabled $c(-disabledfg)]

      ttk::style configure TMenubutton \
        -background $c(-button) \
        -foreground $c(-fg) \
        -padding {10 5 6 5} \
        -arrowcolor $c(-fg)

      ttk::style map TMenubutton \
        -background [list disabled $c(-disabledbg) active $c(-active)] \
        -foreground [list disabled $c(-disabledfg)] \
        -arrowcolor [list disabled $c(-disabledfg)]

      # --------------------------------------------------- checks and radios
      # ttk's "alternate" state is the tristate/mixed indicator.
      if {$c(useimages)} {
        ttk::style element create Checkbutton.indicator image \
          [list $i(cb-off) \
            {alternate disabled} $i(cb-mix-dis) \
            {selected disabled}  $i(cb-on-dis) \
            disabled             $i(cb-off-dis) \
            alternate            $i(cb-mix) \
            selected             $i(cb-on)] \
          -sticky {} -padding {0 0 6 0}

        ttk::style element create Radiobutton.indicator image \
          [list $i(rb-off) \
            {alternate disabled} $i(rb-mix-dis) \
            {selected disabled}  $i(rb-on-dis) \
            disabled             $i(rb-off-dis) \
            alternate            $i(rb-mix) \
            selected             $i(rb-on)] \
          -sticky {} -padding {0 0 6 0}
      }

      foreach cls {TCheckbutton TRadiobutton} {
        ttk::style configure $cls \
          -background $c(-bg) \
          -foreground $c(-fg) \
          -indicatorbackground $c(-inputbg) \
          -indicatorforeground $c(-selectfg) \
          -padding 3

        # Kept for the no-image fallback; harmless when images are in use.
        ttk::style map $cls \
          -indicatorbackground [list \
            {disabled selected} $c(-disabledbg) \
            disabled            $c(-disabledbg) \
            {pressed selected}  $c(-primary) \
            selected            $c(-primary) \
            pressed             $c(-active) \
            active              $c(-active)] \
          -indicatorforeground [list disabled $c(-disabledfg)] \
          -foreground [list disabled $c(-disabledfg)] \
          -bordercolor [list focus $c(-selectbg)]
      }

      # -------------------------------------------------------------- inputs
      ttk::style configure TEntry \
        -fieldbackground $c(-inputbg) \
        -foreground $c(-text) \
        -padding {6 4}

      ttk::style map TEntry \
        -fieldbackground [list readonly $c(-bg) disabled $c(-disabledbg)] \
        -foreground [list disabled $c(-disabledfg)] \
        -bordercolor [list focus $c(-selectbg)] \
        -lightcolor [list focus $c(-selectbg)] \
        -darkcolor [list focus $c(-selectbg)]

      ttk::style configure TCombobox \
        -fieldbackground $c(-inputbg) \
        -foreground $c(-text) \
        -arrowcolor $c(-fg) \
        -padding {6 4}

      ttk::style map TCombobox \
        -fieldbackground [list readonly $c(-button) disabled $c(-disabledbg)] \
        -foreground [list disabled $c(-disabledfg)] \
        -arrowcolor [list disabled $c(-disabledfg)] \
        -bordercolor [list focus $c(-selectbg)] \
        -lightcolor [list focus $c(-selectbg)] \
        -darkcolor [list focus $c(-selectbg)]

      # The dropdown is a classic Tk listbox, outside ttk::style.
      option add *TCombobox*Listbox.background $c(-inputbg) widgetDefault
      option add *TCombobox*Listbox.foreground $c(-text) widgetDefault
      option add *TCombobox*Listbox.selectBackground $c(-selectbg) widgetDefault
      option add *TCombobox*Listbox.selectForeground $c(-selectfg) widgetDefault

      ttk::style configure TSpinbox \
        -fieldbackground $c(-inputbg) \
        -foreground $c(-text) \
        -arrowcolor $c(-fg) \
        -padding {6 4}

      ttk::style map TSpinbox \
        -fieldbackground [list readonly $c(-bg) disabled $c(-disabledbg)] \
        -foreground [list disabled $c(-disabledfg)] \
        -arrowcolor [list disabled $c(-disabledfg)] \
        -bordercolor [list focus $c(-selectbg)] \
        -lightcolor [list focus $c(-selectbg)] \
        -darkcolor [list focus $c(-selectbg)]

      # -------------------------------------------------------------- ranges
      # GTK's scale knob is white in both modes and does not change on hover;
      # clam draws it from the root style, so it needs its own colours. It
      # stays rectangular - a round knob would need shipped artwork.
      # The knob is an image (see knobimage); the widget face stays the
      # window background and the trough keeps the flat dark border.
      ttk::style element create Horizontal.Scale.slider image \
        [list $t(knob) disabled $t(knob-dis)] -sticky {}
      ttk::style element create Vertical.Scale.slider image \
        [list $t(knob) disabled $t(knob-dis)] -sticky {}

      ttk::style configure TScale \
        -background $c(-bg) \
        -troughcolor $c(-trough) \
        -bordercolor $c(-border) \
        -lightcolor $c(-border) \
        -darkcolor $c(-border)

      ttk::style map TScale \
        -troughcolor [list disabled $c(-disabledbg)]

      # GTK gives the progressbar its own darker trough, not the border tone,
      # and draws it much slimmer than clam. clam's pbar element ignores
      # -thickness, so borrow the default theme's, which honours it.
      ttk::style element create Horizontal.Progressbar.pbar \
        from default Horizontal.Progressbar.pbar
      ttk::style element create Vertical.Progressbar.pbar \
        from default Vertical.Progressbar.pbar

      ttk::style configure TProgressbar \
        -background $c(-primary) \
        -troughcolor $c(-progresstrough) \
        -bordercolor $c(-progresstrough) \
        -lightcolor $c(-primary) \
        -darkcolor $c(-primary) \
        -borderwidth 0 \
        -thickness 8

      ttk::style map TProgressbar \
        -background [list disabled $c(-disabledfg)]

      # GTK's scrollbar slider is a muted grey, not the button colour, and
      # turns accent while being dragged.
      ttk::style configure TScrollbar \
        -background $c(-scrollslider) \
        -troughcolor $c(-trough) \
        -arrowcolor $c(-fg) \
        -gripcount 0

      ttk::style map TScrollbar \
        -background [list disabled $c(-disabledbg) \
                          {pressed !disabled} $c(-primary) \
                          active $c(-scrollhover)] \
        -arrowcolor [list disabled $c(-disabledfg)]

      # ---------------------------------------------- frames and notebooks
      ttk::style configure TFrame -background $c(-bg)
      ttk::style configure TLabel -background $c(-bg) -foreground $c(-fg)
      ttk::style map TLabel -foreground [list disabled $c(-disabledfg)]

      ttk::style configure TLabelframe \
        -background $c(-bg) \
        -bordercolor $c(-border) \
        -lightcolor $c(-border) \
        -darkcolor $c(-border)

      ttk::style configure TLabelframe.Label \
        -background $c(-bg) \
        -foreground $c(-fg)

      ttk::style configure TSeparator -background $c(-border)
      ttk::style configure TPanedwindow -background $c(-bg)
      ttk::style configure Sash -sashthickness 6 -gripcount 0

      ttk::style configure TNotebook \
        -background $c(-bg) \
        -bordercolor $c(-border) \
        -tabmargins {0 2 0 0}

      ttk::style element create Notebook.tab image \
        [list $t(normal) selected $t(selected) active $t(active)] \
        -border {1 1 1 2} -padding {14 6} -sticky nsew

      ttk::style configure TNotebook.Tab \
        -background $c(-bg) \
        -foreground $c(-disabledfg) \
        -padding {14 6}

      # GTK dims unselected tab labels and lifts them to full on select.
      ttk::style map TNotebook.Tab \
        -foreground [list selected $c(-fg) \
                          disabled $c(-disabledfg) \
                          active $c(-text)]

      # ------------------------------------------------------------ treeview
      ttk::style configure Treeview \
        -background $c(-inputbg) \
        -fieldbackground $c(-inputbg) \
        -foreground $c(-text) \
        -bordercolor $c(-border) \
        -rowheight 22

      ttk::style map Treeview \
        -background [list selected $c(-selectbg)] \
        -foreground [list selected $c(-selectfg) disabled $c(-disabledfg)]

      # GTK gives the header the same background as the body and separates it
      # typographically instead: bold weight and a muted foreground. Tinting
      # the header was a deviation that read on dark and vanished on light,
      # where button and base are only three points apart.
      ttk::style element create Treeheading.border image $t(heading) \
        -border {0 0 1 0} -sticky nsew

      ttk::style configure Treeview.Heading \
        -background $c(-inputbg) \
        -foreground $c(-headingfg) \
        -font TkHeadingFont \
        -padding {8 5} \
        -relief flat

      # GTK turns the header accent-coloured on hover rather than filling it.
      ttk::style map Treeview.Heading \
        -background [list active $c(-inputbg)] \
        -foreground [list active $c(-primary) disabled $c(-disabledfg)]

      ttk::style configure TSizegrip -background $c(-bg)
    }

    setpalette $opt(-colors)
  }
}
