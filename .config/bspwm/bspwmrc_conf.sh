#!/bin/sh


# Two monitor config
if [[ $(/usr/bin/xrandr -q | /bin/grep " connected " | /usr/bin/wc -l) == 2 ]]; then
    sleep 4s &
    (/usr/bin/xrandr --output DVI-I-1 --mode 1920x1080) &
    (/usr/bin/xrandr --output HDMI-0 --mode 1920x1080) &
    (/usr/bin/xrandr --output HDMI-0 --left-of DVI-I-1) &
    (/usr/bin/xrandr --output HDMI-0 --primary) &
fi


bspc config border_width   2
bspc config window_gap     3
bspc config top_padding   20


    if [[ -n $(xrandr | grep 'HDMI-0 connected') ]]; then
        bspc monitor 'HDMI-0' \
            -d 'dev' 'term' 'git' 'qp' 'disk'
        bspc desktop 'dev'  -l monocle
        bspc desktop 'term' -l tiled
        bspc desktop 'git' -l monocle
        bspc desktop 'qp' -l monocle
        bspc desktop 'disk' -l tiled
    fi

    if [[ -n $(xrandr | grep 'DVI-I-1 connected') ]]; then
        bspc monitor 'DVI-I-1' \
            -d 'web' 'req' 'chat' 'music' 'home'
        bspc desktop 'web' -l tiled
        bspc desktop 'req' -l monocle
        bspc desktop 'chat' -l tiled
        bspc desktop 'music' -l monocle
        bspc desktop 'home' -l monocle
    fi

# bspc monitor 2 --add-desktops "gimp"

# bspc monitor DVI-0 -d D1 D2 D3
# bspc monitor HDMI-2 -d H1 H2 H3

# Visual options
bspc config apply_floating_atom       true
bspc config auto_alternate            true
bspc config auto_cancel               true
bspc config borderless_monocle        true
bspc config center_pseudo_tiled       false
bspc config focus_follows_pointer     true
bspc config focus_by_distance         true
bspc config gapless_monocle           false
bspc config ignore_ewmh_focus         false
bspc config initial_polarity          second_child
bspc config leaf_monocle              true
bspc config pointer_follows_focus     false
bspc config pointer_follows_monitor   true
bspc config remove_unplugged_monitors true
bspc config split_ratio               0.72

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

# bspc rule -a '*' floating=on    ## all windows will floated
# bspc rule -a '*' desktop=music  ## all windows will appear only on selected desktop
bspc rule -a '*'                  private=on    
bspc rule -a chromium             desktop=music 
bspc rule -a Conky                sticky=on      manage=off lower=on
bspc rule -a Gmrun                floating=on    border=off
bspc rule -a MPlayer              floating=on    border=off
bspc rule -a Mysql-workbench-bin  desktop=qp     locked=on
bspc rule -a Nitrogen             floating=on    border=off
bspc rule -a org-zaproxy-zap-ZAP  desktop=qp    
bspc rule -a Pavucontrol          floating=on    border=off
bspc rule -a SmartGit             desktop=git   
bspc rule -a Spacefm              desktop=disk  
bspc rule -a Terminator           locked=on     
bspc rule -a dzen                 lower=on     
bspc rule -a Surf                 floating=on     
bspc rule -a Player               floating=on     
bspc rule -a Leafpad              floating=on     
bspc rule -a Thunar               floating=on    border=off
bspc rule -a Tilda                floating=on    border=off locked=on
bspc rule -a Viewnior             floating=on    border=off
bspc rule -a Xfce4-notifyd        floating=on    border=off sticky=on

bspc config external_rules_command "$HOME/.config/bspwm/external_rules.sh"


