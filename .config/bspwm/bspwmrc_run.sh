#!/bin/sh

# Two monitor config
(xrandr --output DVI-0 --mode 1920x1080) &
(xrandr --output HDMI-2 --mode 1920x1080) &
(sleep 3s && xrandr --output DVI-0 --left-of HDMI-2) &
(xrandr --output DVI-0 --primary) &

(pidof /usr/local/bin/sxhkd || sxhkd) &

## GNOME PolicyKit and Keyring
eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg) &

## Redshift 
# adjusts the color temperature of your screen according to your surroundings. 
# This may help your eyes hurt less if you are working in front of the screen at night.
# This program is inspired by f.lux.

## sample X compositing manager
pidof compton || compton &

# xrdb ~/.Xresources &
wmname LG3D &
xsetroot -cursor_name left_ptr &

## Set root window colour
# hsetroot -solid "#2E3436" &

## Wallpaper
( sleep 4s && nitrogen --restore ) &

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

## Hide mouse pointer after 1 sec idle
unclutter -idle 1 &

## Turn on/off system beep
xset b off &

## Horizontal scroll with shift+mousewheel
xbindkeys &

## Add russian layout
setxkbmap -layout us,ru -option grp:caps_toggle -option grp_led:num &

## layout tray indicator
# sbxkb & 

## Enable power management
(pidof xfce4-power-manager || xfce4-power-manager) &

## Start Thunar Daemon
(pidof /usr/bin/thunar || thunar --daemon) &

## Volume icon
(pidof /usr/bin/volumeicon || /usr/bin/volumeicon) &

## Enable Eyecandy - off by default, uncomment one of the commands below.
## Note: cairo-compmgr prefers a sleep delay, else it tends to produce
## odd shadows/quirks around tint2 & Conky.
#(sleep 10s && gb-compmgr --cairo-compmgr) &
#gb-compmgr --xcompmgr & 

## Panels
tint2 &
(pidof dzen2 || $HOME/bin/panel/panel.sh) &
# (sleep 4s && PATH=$PATH:/home/morock/.config/bspwm/panel PANEL_FIFO="/tmp/panel-fifo" panel) &

## Launch network manager applet
(sleep 3s && (pidof nm-applet || nm-applet)) &

## Start xscreensaver
(pidof xscreensaver || xscreensaver -no-splash) &

## Start Clipboard manager
(sleep 3s && (pidof clipit || clipit)) &

## Top tilda
(sleep 3s && (pidof tilda || tilda)) &

## Right ALT = Super_Lq
# xmodmap -e "keycode 108 = Super_L" &
# xmodmap -e "remove mod1 = Super_L" &

## Fix for normal mouse click on statusbar for non-english layouts
# for awesome wm
# xkbcomp $DISPLAY - | egrep -v "group . = AltGr;" | xkbcomp - $DISPLAY &

# [ ! -s ~/.mpd/pid ] && mpd &
