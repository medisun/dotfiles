#! /bin/sh
#
#

desktop=$1
monitor=$2

if [ -z "$monitor" ]; then
    monitor='focused'
fi

[ $(bspc query -m "${monitor}" -D --names | grep "${desktop}") ] || bspc monitor "$monitor" --add-desktops "$desktop"
