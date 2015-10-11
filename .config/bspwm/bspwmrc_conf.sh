#!/bin/sh

bspc config border_width   2
bspc config window_gap     3
bspc config top_padding   24

i=1
for monitor in $(bspc query -M); do
    bspc monitor $monitor \
        -n "$i" \
        -d "D${i}1" "D${i}2" "D${i}3"  "D${i}4" "D${i}5"

    if [ $i -eq '1' ]; then
        bspc desktop ^1 -n "dev"  -l monocle
        bspc desktop ^2 -n "term" -l tiled
        bspc desktop ^3 -n "staff" -l monocle
        bspc desktop ^4 -n "zap" -l tiled
        bspc desktop ^5 -n "disk" -l tiled
    fi

    if [ $i -eq '2' ]; then
        bspc desktop ^6 -n "web" -l monocle
        bspc desktop ^7 -n "req" -l monocle
        bspc desktop ^8 -n "chat" -l tiled
        bspc desktop ^9 -n "music" -l monocle
        bspc desktop ^10 -n "home" -l monocle
    fi

    i=$((i+1))
done
unset i

# bspc monitor DVI-0 -d D1 D2 D3
# bspc monitor HDMI-2 -d H1 H2 H3

# Visual options
bspc config apply_floating_atom       true
bspc config auto_alternate            true
bspc config auto_cancel               true
bspc config borderless_monocle        true
bspc config leaf_monocle              true
bspc config center_pseudo_tiled       false
bspc config focus_follows_pointer     true
bspc config gapless_monocle           false
bspc config ignore_ewmh_focus         false
bspc config pointer_follows_focus     false
bspc config pointer_follows_monitor   true
bspc config remove_unplugged_monitors true
bspc config split_ratio         0.72

# Color of the border of a focused window of a focused monitor.
bspc config focused_border_color "#839698"
# Color of the border of a focused window of an unfocused monitor.
bspc config active_border_color "#4f4742"
# Color of the border of an unfocused window.
bspc config normal_border_color "#4f4742"
# Color of the presel message feedback.
bspc config presel_border_color "#ffbc00"
# Color of the border of a focused locked window of a focused monitor.
bspc config focused_locked_border_color "#ffffff"
# Color of the border of a focused locked window of an unfocused monitor.
bspc config active_locked_border_color "#4f4742"
# Color of the border of an unfocused locked window.
bspc config normal_locked_border_color "#4f4742"
# Color of the border of a focused sticky window of a focused monitor.
bspc config focused_sticky_border_color "#80129b"
# Color of the border of a focused sticky window of an unfocused monitor.
bspc config active_sticky_border_color "#4f4742"
# Color of the border of an unfocused sticky window.
bspc config normal_sticky_border_color "#4f4742"
# Color of the border of a focused private window of a focused monitor.
bspc config focused_private_border_color "#61bfe2"
# Color of the border of a focused private window of an unfocused monitor.
bspc config active_private_border_color "#4f4742"
# Color of the border of an unfocused private window.
bspc config normal_private_border_color "#4f4742"
# Color of the border of an urgent window.
bspc config urgent_border_color "#ff4027"


bspc config normal_frame_opacity 0.0
bspc config focused_frame_opacity 0.0


# Rules
# 
# -a, --add <class_name>|<instance_name>|* 
#           [-o|--one-shot] [monitor=MONITOR_SEL|desktop=DESKTOP_SEL|window=WINDOW_SEL] 
#           [(floating|fullscreen|pseudo_tiled|locked|sticky|private|center|follow|manage|focus|border)=(on|off)] 
#           [split_dir=DIR] [split_ratio=RATIO]
# 
#     Create a new rule.
# -r, --remove ^<n>|head|tail|<class_name>|<instance_name>|*…
# 
#     Remove the given rules.
# -l, --list [<class_name>|<instance_name>|*]
# 
#     List the rules.

# Remove all previous rules
bspc rule -l | sed "s/^\(.*\) => \(.*\)/'\1' /" | xargs bspc rule -r

# bspc rule -a '*' floating=on
# tildabspc rule -a '*' desktop=music floating=on ## all windows will appear only on selected desktop
bspc rule -a '*' private=on
bspc rule -a Mysql-workbench-bin locked=on desktop=staff
bspc rule -a Terminator locked=on
bspc rule -a Sublime_text desktop=dev
bspc rule -a Firefox locked=on
bspc rule -a Chromium desktop=music
bspc rule -a Conky sticky=on manage=off lower=on
bspc rule -a Tilda floating=on border=off locked=on
bspc rule -a Gmrun floating=on border=off
bspc rule -a Viewnior floating=on border=off
bspc rule -a MPlayer floating=on border=off
bspc rule -a Nitrogen floating=on border=off
bspc rule -a Pavucontrol floating=on border=off
bspc rule -a Skype split_dir=left desktop=chat split_ratio=0.4

bspc config external_rules_command "$HOME/.config/bspwm/external_rules.sh"


