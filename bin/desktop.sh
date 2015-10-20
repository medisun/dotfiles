#! /bin/sh
#
#

desktop=$1
monitor=$2

if [ -z "$monitor" ]; then
    monitor=$(bspc query -M | head -n1)
fi

[ $(bspc query -m "$monitor" -D | grep "${desktop}") ] || bspc monitor "$monitor" --add-desktops "$desktop"
