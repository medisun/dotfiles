#!/bin/sh

bspc monitor -d "dev" "term" "git" "zap" "sql" "disk" "ff" "req" "email" "hip" "chat" "chrome" "home"

    bspc desktop "dev"    -l monocle
    bspc desktop "term"   -l tiled
    bspc desktop "git"    -l monocle
    bspc desktop "zap"    -l monocle
    bspc desktop "sql"    -l tiled
    bspc desktop "disk"   -l tiled
    bspc desktop "ff"     -l tiled
    bspc desktop "req"    -l monocle
    bspc desktop "email"  -l tiled
    bspc desktop "hip"    -l tiled
    bspc desktop "chat"  -l tiled
    bspc desktop "chrome" -l tiled
    bspc desktop "home"   -l tiled


bspc config border_width   2
bspc config window_gap     2
bspc config -m LVDS1 top_padding 20
bspc config right_padding  2
bspc config bottom_padding 2
bspc config left_padding   2

# shift, control, lock, mod1, mod2, mod3, mod4, mod5.
bspc config pointer_modifier mod1
# move, resize_side, resize_corner, focus, none.
bspc config pointer_action1 move
bspc config pointer_action2 resize_side
bspc config pointer_action3 resize_corner
bspc config pointer_motion_interval 5

# Visual options
bspc config remove_disabled_monitors     true
bspc config remove_unplugged_monitors    true
bspc config merge_overlapping_monitors   true

bspc config center_pseudo_tiled       false
bspc config initial_polarity          first_child    # first_child, second_child.
bspc config split_ratio               0.66

bspc config click_to_focus            false
bspc config focus_follows_pointer     true
bspc config pointer_follows_focus     false
bspc config pointer_follows_monitor   true
bspc config ignore_ewmh_focus         false
bspc config honor_size_hints          true

bspc config single_monocle            true
bspc config paddingless_monocle       false
bspc config borderless_monocle        true
bspc config gapless_monocle           false

bspc config normal_border_color "#4f4742"
bspc config active_border_color "#4f4742"
bspc config focused_border_color "#3ACDF2"
bspc config presel_feedback_color "#ffbc00"

##
##     List the rules.
##
asdasd
# Remove all previous rules
bspc rule -l | sed "s/^\(.*\) => \(.*\)/'\1' /" | xargs bspc rule -r

# bspc rule -a '*' state=floating    ## all windows will floated
# bspc rule -a '*' desktop=music  ## all windows will appear only on selected desktop
# bspc rule -a '*'                  node=newer.same_class
bspc rule -a '*'                  private=on
bspc rule -a Atom                 state=floating    border=off
bspc rule -a Conky                sticky=on         manage=off lower=on
bspc rule -a dzen                 border=off        sticky=on  layer=below
bspc rule -a Gmrun                state=floating    border=off
bspc rule -a Geany                state=floating    border=off
bspc rule -a gnome-pie-496        border=off        sticky=on  layer=abowe
bspc rule -a gnome-pie-988        border=off        sticky=on  layer=abowe
bspc rule -a HipChat              desktop=hip
bspc rule -a Leafpad              state=floating
bspc rule -a MPlayer              state=floating    border=off
bspc rule -a Mysql-workbench-bin  desktop=sql       locked=on
bspc rule -a Nitrogen             state=floating    border=off focus=off
bspc rule -a org-zaproxy-zap-ZAP  desktop=zap
bspc rule -a Pavucontrol          state=floating    border=off
bspc rule -a Player               state=floating
bspc rule -a Gucharmap            state=floating
bspc rule -a SmartGit             desktop=git
bspc rule -a Spacefm              desktop=disk
bspc rule -a Surf                 state=floating
bspc rule -a Terminator           locked=on
bspc rule -a Meld                 locked=on
bspc rule -a Min                  desktop=M
bspc rule -a Thunar               state=floating
bspc rule -a Tilda                state=floating    border=off locked=on
bspc rule -a Tint2                border=off        sticky=on  layer=below
bspc rule -a Viewnior             state=floating
bspc rule -a Xfce4-notifyd        state=floating    border=off sticky=on layer=above
bspc rule -a 'NetBeans IDE 8.1'     desktop=nb

bspc config external_rules_command "$HOME/.config/bspwm/external_rules.sh"
