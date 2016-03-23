#!/bin/sh

if [[ -n $(xrandr | grep 'HDMI-0 connected') ]]; then

    bspc monitor 'HDMI-0' \
        -d "dev" "term" "git" "zap" "sql" "disk"

    bspc desktop "dev"    -l monocle
    bspc desktop "term"   -l tiled
    bspc desktop "git"    -l monocle
    bspc desktop "zap"    -l monocle
    bspc desktop "sql"    -l tiled
    bspc desktop "disk"   -l tiled
fi

if [[ -n $(xrandr | grep 'DVI-I-1 connected') ]]; then

    bspc monitor 'DVI-I-1' \
        -d "ff" "req" "chat" "chrome" "home"

    bspc desktop "ff"     -l tiled
    bspc desktop "req"    -l monocle
    bspc desktop "chat"   -l tiled
    bspc desktop "chrome" -l tiled
    bspc desktop "home"   -l tiled
fi

bspc config border_width   2
bspc config window_gap     3
bspc config top_padding    20
bspc config right_padding  2
bspc config bottom_padding 2
bspc config left_padding   2

# Visual options
bspc config remove_disabled_monitors     true
bspc config remove_unplugged_monitors    true
bspc config merge_overlapping_monitors   true

# bspc config apply_floating_atom          true
# bspc config auto_alternate               true
# bspc config auto_cancel                  true

bspc config center_pseudo_tiled       true
bspc config initial_polarity          second_child    # first_child, second_child.
bspc config split_ratio               0.66

bspc config history_aware_focus       true
bspc config focus_follows_pointer     true
bspc config focus_by_distance         false
bspc config pointer_follows_focus     false
bspc config pointer_follows_monitor   true
bspc config ignore_ewmh_focus         false

bspc config single_monocle            true
bspc config paddingless_monocle       false
bspc config borderless_monocle        true
bspc config gapless_monocle           false
bspc config leaf_monocle              true


# Color of the border of a focused window of a focused monitor.
bspc config focused_border_color "#839698"
# Color of the border of a focused window of an unfocused monitor.
bspc config active_border_color "#4f4742"
# Color of the border of an unfocused window.
bspc config normal_border_color "#4f4742"
# Color of the border of an urgent window.
bspc config urgent_border_color "#ff4027"

# Color of the presel message feedback.
bspc config presel_feedback_color "#ffbc00"

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

# bspc config normal_frame_opacity 0.0
# bspc config focused_frame_opacity 0.0

##
##     List the rules.
##

# Remove all previous rules
bspc rule -l | sed "s/^\(.*\) => \(.*\)/'\1' /" | xargs bspc rule -r

# bspc rule -a '*' state=floating    ## all windows will floated
# bspc rule -a '*' desktop=music                     ## all windows will appear only on selected desktop

bspc rule -a Chromium             desktop=chrome
bspc rule -a Conky                sticky=on         manage=off layer=lower
bspc rule -a Gmrun                state=floating    border=off
bspc rule -a MPlayer              state=floating    border=off
bspc rule -a Mysql-workbench-bin  desktop=sql       locked=on
bspc rule -a Nitrogen             state=floating    border=off
bspc rule -a org-zaproxy-zap-ZAP  desktop=zap
bspc rule -a Pavucontrol          state=floating    border=off
bspc rule -a Skype                split_dir=left    desktop=chat split_ratio=0.4
bspc rule -a SmartGit             desktop=git
bspc rule -a Spacefm              desktop=disk
bspc rule -a Sublime_text         desktop=dev
bspc rule -a Terminator           locked=on
bspc rule -a Thunar               state=floating    border=off
bspc rule -a Tilda                state=floating    border=off locked=on
bspc rule -a 'Main.py'            state=floating    border=off locked=on
bspc rule -a Viewnior             state=floating    border=off
bspc rule -a Xfce4-notifyd        state=floating    border=off sticky=on layer=above
bspc rule -a Tint2                border=off        sticky=on  layer=above

# bspc rule -a '*' state=floating    ## all windows will floated
# bspc rule -a '*' desktop=music  ## all windows will appear only on selected desktop
bspc rule -a '*'                  private=on
bspc rule -a Conky                sticky=on      manage=off lower=on
bspc rule -a Gmrun                state=floating    border=off
bspc rule -a Atom                 state=floating    border=off
bspc rule -a MPlayer              state=floating    border=off
bspc rule -a Mysql-workbench-bin  desktop=sql        flag=locked
bspc rule -a Nitrogen             state=floating    border=off
bspc rule -a org-zaproxy-zap-ZAP  desktop=zap
bspc rule -a Pavucontrol          state=floating    border=off
bspc rule -a SmartGit             desktop=git
bspc rule -a Spacefm              desktop=disk
bspc rule -a Terminator           flag=locked     
bspc rule -a dzen                 lower=on
bspc rule -a Surf                 state=floating
bspc rule -a Player               state=floating
bspc rule -a Leafpad              state=floating
bspc rule -a Thunar               state=floating    border=off
bspc rule -a Tilda                state=floating    border=off flag=locked
bspc rule -a Viewnior             state=floating    border=off
bspc rule -a Xfce4-notifyd        state=floating    border=off sticky=on layer=above
bspc rule -a Tint2                border=off        sticky=on  layer=above

bspc config external_rules_command "$HOME/.config/bspwm/external_rules.sh"
