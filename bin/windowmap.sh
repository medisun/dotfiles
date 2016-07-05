#! /bin/sh
#
#

WINDOW_STACK="${HOME}/.cache/windowmap"

PLACE_TO_CURRENT_DESKTOP=true

if [ "$1" == "-d" ]; then
    PLACE_TO_CURRENT_DESKTOP=false
else
    wid=$1
fi

if [ -z "${wid}" ]; then
    wid=$(tail -n1 "${WINDOW_STACK}")
    # [ -n "${wid}" ] && sed -i '$ d' "${WINDOW_STACK}" && xdotool windowmap "${wid}"
    if [ -n "${wid}" ] && sed -i '$ d' "${WINDOW_STACK}"; then
        [ $PLACE_TO_CURRENT_DESKTOP ] && bspc node "${wid}" --to-desktop focused
        bspc node "${wid}" --flag hidden=off
        bspc node "${wid}" --focus
    fi
else
    # xdotool windowunmap "$wid"
    echo "${wid}" >> "${WINDOW_STACK}"
    bspc node "${wid}" --flag hidden=on
fi
