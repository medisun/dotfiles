#/bin/bash

COLOR_FG='#afafaf'
COLOR_BG='#1f1f1f'
FONT='-*-terminus-medium-r-normal-*-12-120-72-72-c-60-*-*'

SESSION_FOLDER=$(dirname "${BSPWM_SOCKET}")
WINDOW_STACK="${SESSION_FOLDER}/windowmap"


eval $(xdotool getmouselocation --shell)

C=$(cat ${WINDOW_STACK} | wc -l)

cat "${WINDOW_STACK}" | (
    while read -r wid; do
        wname=$(xtitle -et25 "${wid}")
        echo "^ca(1, /home/morock/bin/windowmap.sh ${wid}) ${wname} ^ca()"
        C=$((C+1))
    done
) | dzen2 -p -x "$X" -y "$Y" -l "$C" -w "250" -sa 'l' -ta 'l' -fg $COLOR_FG -bg $COLOR_BG -fn $FONT\
    -title-name 'popup_window_mapping' -e 'onstart=uncollapse;button3=exit'

 # "onstart=uncollapse" ensures that slave window is visible from start.
