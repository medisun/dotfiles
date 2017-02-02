#! /bin/sh
#
#

WINDOW_STACK="${HOME}/.cache/windowmap"
PLACE_TO_CURRENT_DESKTOP=true
WINDOW_ID=""

function get_opt_args() {
    # while getopts ":dw:" opt
    while getopts "dw:" opt
    do
        case $opt in
        "w")
            WINDOW_ID="$OPTARG"
             ;;
        "d")
            PLACE_TO_CURRENT_DESKTOP=false
            ;;
        ":")
            echo "No argument value for option -$OPTARG"
            ;;
        esac
    done
    shift $((OPTIND-1))
}

get_opt_args $@

# show window
if [ -z "${WINDOW_ID}" ]; then
    WINDOW_ID=$(tail -n1 "${WINDOW_STACK}")

    if [ -n "${WINDOW_ID}" ] && sed -i '$ d' "${WINDOW_STACK}"; then
        if [ "$PLACE_TO_CURRENT_DESKTOP" = true ]; then
            bspc node "${WINDOW_ID}" --to-desktop focused
        else
            bspc node "${WINDOW_ID}" --focus
        fi

        # old realization with xdotool
        # xdotool windowmap "${WINDOW_ID}"
        # new one
        bspc node "${WINDOW_ID}" --flag hidden=off
    fi
    
# hide window
else
    echo "${WINDOW_ID}" >> "${WINDOW_STACK}"
    # xdotool windowunmap "${WINDOW_ID}"
    bspc node "${WINDOW_ID}" --flag hidden=on
fi
