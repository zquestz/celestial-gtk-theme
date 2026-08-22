#! /usr/bin/env wish
#
# Celestial ttk widget gallery.
#
# Iteration harness for the ttk themes in this directory. Shows every themed
# widget class in each state, plus the classic Tk widgets that ttk::style does
# not reach, so regressions in either half are visible at a glance.
#
# Usage:
#   wish gallery.tcl                        # default theme
#   wish gallery.tcl clam                   # a built-in theme
#   wish gallery.tcl celestial-azul-dark    # sources the matching .tcl here

set here [file dirname [file normalize [info script]]]

# This directory carries a pkgIndex.tcl, so putting it on auto_path makes the
# local variants selectable from the theme dropdown without any install.
# Prepended, so on a machine that also has the themes installed system-wide
# the gallery exercises the in-tree code, not the installed copy.
if {[lsearch -exact $auto_path $here] < 0} {
  set auto_path [linsert $auto_path 0 $here]
}

set requested [lindex $argv 0]

if {$requested ne ""} {
  set themefile [file join $here $requested.tcl]
  if {[file exists $themefile]} {
    source $themefile
  } else {
    # Fall back to the package path, so themes installed on auto_path (our own
    # once installed, or a third party's) can be compared against side by side.
    foreach pkg [list ttk::theme::$requested $requested] {
      if {![catch {package require $pkg}]} break
    }
  }
  if {[lsearch -exact [ttk::style theme names] $requested] >= 0} {
    ttk::style theme use $requested
  } else {
    puts stderr "unknown theme '$requested'; using [ttk::style theme use]"
  }
}

wm title . "Celestial ttk gallery - [ttk::style theme use]"

# Every section is built twice: once enabled, once disabled, so the disabled
# state of each widget sits directly beneath its normal state.
proc section {parent title} {
  set name [string tolower [string map {" " _} $title]]
  set f [ttk::labelframe $parent.$name -text $title -padding 8]
  pack $f -fill x -padx 10 -pady 6
  return $f
}

proc bothstates {f builder} {
  foreach state {normal disabled} {
    set row [ttk::frame $f.row$state]
    pack $row -fill x -pady 2
    ttk::label $row.tag -text $state -width 9
    pack $row.tag -side left -padx {0 8}
    {*}$builder $row
    if {$state eq "disabled"} {
      foreach w [winfo children $row] {
        if {$w ne "$row.tag"} { catch {$w state disabled} ; catch {$w configure -state disabled} }
      }
    }
  }
}

set nb [ttk::notebook .nb]
pack $nb -fill both -expand 1 -padx 10 -pady 10

# ---------------------------------------------------------------- ttk widgets
set p1 [ttk::frame $nb.themed -padding 6]
$nb add $p1 -text "Themed"

set f [section $p1 "Buttons"]
bothstates $f {apply {{row} {
  ttk::button $row.b -text "Button"
  ttk::button $row.d -text "Default" -default active
  ttk::menubutton $row.m -text "Menubutton"
  ttk::checkbutton $row.c -text "Check" -variable ::chk
  ttk::checkbutton $row.c2 -text "Checked" -variable ::chkon
  ttk::checkbutton $row.c3 -text "Mixed"
  $row.c3 state alternate
  ttk::radiobutton $row.r -text "Radio" -variable ::rad -value a
  ttk::radiobutton $row.r2 -text "Selected" -variable ::rad -value b
  ttk::radiobutton $row.r3 -text "Mixed"
  $row.r3 state alternate
  pack $row.b $row.d $row.m $row.c $row.c2 $row.c3 $row.r $row.r2 $row.r3 \
    -side left -padx 3
}}}

set f [section $p1 "Entries"]
bothstates $f {apply {{row} {
  ttk::entry $row.e
  $row.e insert 0 "Entry"
  ttk::combobox $row.cb -values {One Two Three}
  $row.cb set "Combobox"
  ttk::spinbox $row.sp -from 0 -to 10
  $row.sp set 5
  pack $row.e $row.cb $row.sp -side left -padx 3
}}}

set f [section $p1 "Ranges"]
bothstates $f {apply {{row} {
  ttk::scale $row.s -from 0 -to 100 -value 40 -length 130
  ttk::progressbar $row.p -value 60 -length 130
  ttk::progressbar $row.p2 -value 40 -length 130 -mode indeterminate
  ttk::scrollbar $row.sb -orient horizontal
  $row.sb set 0.2 0.6
  pack $row.s $row.p $row.p2 -side left -padx 3
  pack $row.sb -side left -padx 3 -fill x -expand 1
}}}

set f [section $p1 "Labels and separators"]
bothstates $f {apply {{row} {
  ttk::label $row.l -text "Label"
  ttk::separator $row.sep -orient vertical
  ttk::label $row.l2 -text "Another label"
  ttk::sizegrip $row.sg
  pack $row.l -side left -padx 3
  pack $row.sep -side left -padx 8 -fill y
  pack $row.l2 $row.sg -side left -padx 3
}}}

# ------------------------------------------------------------------- treeview
set p2 [ttk::frame $nb.tree -padding 6]
$nb add $p2 -text "Treeview"

set tv [ttk::treeview $p2.tv -columns {size kind} -height 8]
$tv heading #0 -text "Name"
$tv heading size -text "Size"
$tv heading kind -text "Kind"
$tv column size -width 90
$tv column kind -width 120
set root [$tv insert {} end -text "src" -open 1]
foreach {n s k} {
  gtk        "12 files"  "directory"
  cinnamon   "9 files"   "directory"
  extra      "13 files"  "directory"
} { $tv insert $root end -text $n -values [list $s $k] }
set sel [$tv insert $root end -text "install.sh" -values {"48 KB" "script"}]
$tv selection set $sel
pack $tv -fill both -expand 1 -padx 10 -pady 10

# -------------------------------------------------------------- classic widgets
# ttk::style does not reach these; they follow tk_setPalette and the option
# database instead. If these look wrong, the theme's palette block is at fault.
set p3 [ttk::frame $nb.classic -padding 6]
$nb add $p3 -text "Classic Tk"

set f [section $p3 "Not covered by ttk::style"]
set row [ttk::frame $f.row]
pack $row -fill both -expand 1

listbox $row.lb -height 6 -width 18
foreach v {Sea Aliz Azul Pueril} { $row.lb insert end $v }
$row.lb selection set 2

text $row.tx -height 6 -width 34 -wrap word
$row.tx insert end "Classic Tk text widget.\n\nColoured via tk_setPalette, not ttk::style."

button $row.btn -text "tk::button"
pack $row.lb $row.tx $row.btn -side left -padx 6 -pady 4 -anchor n

# ----------------------------------------------------------------- theme switch
set bar [ttk::frame .bar -padding {10 0 10 10}]
pack $bar -fill x
ttk::label $bar.l -text "Theme:"
# ttk::themes lists registered theme packages as well as loaded themes, so
# every installed or in-tree variant is offered; loading happens on selection.
ttk::combobox $bar.c -values [lsort [ttk::themes]] -state readonly -width 26
$bar.c set [ttk::style theme use]
bind $bar.c <<ComboboxSelected>> {
  set pick [%W get]
  if {[lsearch -exact [ttk::style theme names] $pick] < 0} {
    catch {package require ttk::theme::$pick}
  }
  if {[lsearch -exact [ttk::style theme names] $pick] >= 0} {
    ttk::style theme use $pick
  }
  wm title . "Celestial ttk gallery - [ttk::style theme use]"
}
pack $bar.l $bar.c -side left -padx 3

# An unset checkbutton variable renders as the tristate "alternate" state, so
# give the plain check an explicit off value.
set ::chk 0
set ::chkon 1
set ::rad b

# Optional second argument selects a tab by index, so screenshots of a given
# page can be scripted without clicking through window-manager offsets.
set wanted [lindex $argv 1]
if {$wanted ne ""} { catch {$nb select $wanted} }
