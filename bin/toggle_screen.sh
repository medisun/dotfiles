#!/bin/bash

## Execute xrandr to do double screen. Added 20/04/13
(xrandr --output VGA1 --mode 1920x1080) &
(xrandr --output LVDS1 --mode 1366x768) &
(sleep 3s && xrandr --output VGA1 --left-of LVDS1) &
(xrandr --output VGA1 --primary) &
sleep 6s && nitrogen --restore
