#!/usr/bin/env bash

## Setup second monitor
# (xrandr --output VGA-1 --mode 1920x1080) &
# (xrandr --output DVI-I-1 --mode 1920x1080) &
# (sleep 3s && xrandr --output VGA-1 --left-of DVI-I-1) &
# (xrandr --output VGA-1 --primary) &

## GNOME PolicyKit and Keyring
eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg) &

## Redshift 
# adjusts the color temperature of your screen according to your surroundings. 
# This may help your eyes hurt less if you are working in front of the screen at night.
# This program is inspired by f.lux.
redshift -l 50.0318313:36.2242183 &

## sample X compositing manager
pidof compton || compton &

xrdb ~/.Xresources &
wmname LG3D &
xsetroot -cursor_name left_ptr &

## Set root window colour
# hsetroot -solid "#2E3436" &

## Wallpaper
nitrogen --restore

## Bspwm keybindings daemon
sxhkd &

## Set keyboard settings - 250 ms delay and 25 cps (characters per second) repeat rate.
## Adjust the values according to your preferances.
xset r rate 250 25 &

## Set mouse speed
xset m 3 3 &

## Detect and configure touchpad. See 'man synclient' for more info.
if egrep -iq 'touchpad' /proc/bus/input/devices; then
    synclient VertEdgeScroll=1 &
    synclient TapButton1=1 &
fi

## Turn on/off system beep
xset b off &

## Horizontal scroll with shift+mousewheel
xbindkeys &

## Add russian layout
setxkbmap -layout us,ru -option grp:caps_toggle -option grp_led:num

## Enable power management
xfce4-power-manager &

## Start Thunar Daemon
thunar --daemon &

## Launch panel
# tint2 &

## Enable Eyecandy - off by default, uncomment one of the commands below.
## Note: cairo-compmgr prefers a sleep delay, else it tends to produce
## odd shadows/quirks around tint2 & Conky.
#(sleep 10s && gb-compmgr --cairo-compmgr) &
#gb-compmgr --xcompmgr & 

## Launch network manager applet
(sleep 4s && (pidof nm-applet || nm-applet)) &

## Start xscreensaver
pidof xscreensaver || xscreensaver -no-splash &

## Start Clipboard manager
(sleep 3s && (pidof clipit || clipit)) &

## Top tilda
(sleep 5s && (pidof tilda || tilda)) &

## Right ALT = Super_L
# xmodmap -e "keycode 108 = Super_L" &
# xmodmap -e "remove mod1 = Super_L" &

## Fix for normal mouse click on statusbar for non-english layouts
# for awesome wm
# xkbcomp $DISPLAY - | egrep -v "group . = AltGr;" | xkbcomp - $DISPLAY &

[ ! -s ~/.config/mpd/pid ] && mpd &
