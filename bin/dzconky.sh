#!/bin/sh
 
 FG='#aaaaaa'
 BG='#1a1a1a'
 FONT='-*-Monospace-*-r-normal-*-*-120-*-*-*-*-iso8859-*'
 conky -c /home/hasq/bin/dzenconkyrc | dzen2 -e - -h '16' -w '600' -ta r -fg $FG -bg $BG -fn $FONT &

exit 0
