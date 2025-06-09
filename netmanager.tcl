encoding system utf-8

package require Tk

proc changeNet { ssid } {
    if {$ssid != $::current} {
        exec nmcli connection up "$ssid"
    }
    
    if {[file exists ~/bin/connection.tmp]} {
        file delete ~/bin/connection.tmp
    }
    exit
}

wm withdraw .
set ::nmmenu [menu .nmPopup -tearoff 0]
set first true
set ::checked 1
set ::current ""

exec nmcli connection show > ~/bin/connection.tmp
set fp [open ~/bin/connection.tmp]
set data [read $fp]
close $fp

foreach line [split $data "\n"] {
    set parts [split $line " "]
    set name "[lindex $parts 0] [lindex $parts 1]"
    if {$name != "NAME " && $name != " "} {
        if {$first == true} {
            set ::current "$name"
            $::nmmenu add checkbutton -label $name -command [list ::changeNet "$name"] -variable ::checked
            set first false
        } else {
            $::nmmenu add command -label $name -command [list ::changeNet "$name"]
        }
    }
}
tk_popup $::nmmenu 500 200





