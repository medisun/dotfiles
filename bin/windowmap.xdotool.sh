#! /bin/sh
#
#

wid=$1

if [ -n "$BSPWM_SOCKET" ]; then
    SESSION_FOLDER=$(dirname "${BSPWM_SOCKET}")
else  
    echo 'BSPWM_SOCKET is not defined'
    exit 1
fi

WINDOW_STACK="${SESSION_FOLDER}/windowmap"

if [ -z "${wid}" ]; then
    wid=$(tail -n1 "${WINDOW_STACK}")
    [ -n "${wid}" ] && sed -i '$ d' "${WINDOW_STACK}" && xdotool windowmap "${wid}"
else
    xdotool windowunmap "$wid"
    echo "${wid}" >> "${WINDOW_STACK}"
fi
