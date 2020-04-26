#!/bin/sh

bspc monitor -d "tt" "dev" "ff" "term" "git" "zap" "sql" "fs" "req" "email" "skype" "tg" "chrome" "ms" "home" "vm"

    bspc desktop "dev"    -l monocle
    bspc desktop "git"    -l monocle
    bspc desktop "zap"    -l monocle
    bspc desktop "req"    -l monocle
    bspc desktop "tg"     -l monocle
    bspc desktop "vm"     -l monocle


bspc config border_width   1
bspc config window_gap     0
bspc config top_padding    0
bspc config left_padding   0
bspc config bottom_padding 0
bspc config right_padding  0
bspc config -m LVDS1 bottom_padding 16

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
bspc config initial_polarity          second_child    # first_child, second_child.
bspc config split_ratio               0.5

bspc config click_to_focus            false
bspc config focus_follows_pointer     true
bspc config pointer_follows_focus     false
bspc config pointer_follows_monitor   false
bspc config ignore_ewmh_focus         false
bspc config honor_size_hints          true

bspc config single_monocle            true
bspc config paddingless_monocle       false
bspc config borderless_monocle        true
bspc config gapless_monocle           false

bspc config normal_border_color "#4f4742"
bspc config active_border_color "#4f4742"
# bspc config focused_border_color "#3ACDF2"
bspc config focused_border_color "#968800"
bspc config presel_feedback_color "#ffbc00"

##
##     List the rules.
##

# Remove all previous rules
bspc rule -l | sed "s/^\(.*\) => \(.*\)/'\1' /" | xargs bspc rule -r

# bspc rule -a '*' state=floating    ## all windows will floated
# bspc rule -a '*' desktop=music  ## all windows will appear only on selected desktop
# bspc rule -a '*'                  node=newer.same_class
# bspc rule -a '*'                  private=on
bspc rule -a '*'                  border=on
bspc rule -a Atom                 state=floating
bspc rule -a Conky                sticky=on         manage=off lower=on
bspc rule -a dzen                 border=off        sticky=on  layer=below
bspc rule -a Gmrun                state=floating
bspc rule -a Geany                state=floating
bspc rule -a Gnome-todo           state=floating
bspc rule -a HipChat              desktop=hip
bspc rule -a FFdev                desktop=ff
bspc rule -a Leafpad              state=floating
bspc rule -a MPlayer              state=floating
bspc rule -a Mysql-workbench-bin  desktop=sql       locked=on
bspc rule -a Nitrogen             state=floating    focus=off
bspc rule -a org-zaproxy-zap-ZAP  desktop=zap
bspc rule -a Hexchat              desktop=chat
bspc rule -a discord              desktop=chat
bspc rule -a Pavucontrol          state=floating
bspc rule -a Player               state=floating
bspc rule -a Gucharmap            state=floating
bspc rule -a SmartGit             desktop=git
bspc rule -a Spacefm              desktop=fs
bspc rule -a 'Skype Preview'      desktop=skype
bspc rule -a Surf                 state=floating
bspc rule -a Terminator           locked=on
bspc rule -a TelegramDesktop      desktop=tg
bspc rule -a Meld                 locked=on
bspc rule -a Min                  desktop=ms
bspc rule -a cantata              desktop=ms
bspc rule -a Thunar               state=floating
bspc rule -a Tilda                state=floating    border=off locked=on
bspc rule -a Tint2                border=off        sticky=on  layer=below
bspc rule -a Viewnior             state=floating
bspc rule -a VirtualBox           desktop=vm
bspc rule -a Xfce4-notifyd        state=floating    border=off sticky=on layer=above
bspc rule -a 'NetBeans IDE 8.1'   desktop=nb

bspc config external_rules_command "$HOME/.config/bspwm/external_rules.sh"
