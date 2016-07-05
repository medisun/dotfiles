#! /bin/sh

SRCDIR="$(dirname "$0")"

. "$SRCDIR/panel_colors"

num_mon=$(bspc query -M | wc -l)

# SESSION_FOLDER=$(dirname "${BSPWM_SOCKET}")
# WINDOW_STACK="${SESSION_FOLDER}/windowmap"

while read -r line ; do
    case $line in
        # S*)
        #   # clock output
        #   sys_infos="^fg($COLOR_STATUS_FG)^bg($COLOR_STATUS_BG) ${line#?} ^bg()^fg()"
        #   ;;
        # T*)
        #   # xtitle output
        #   title="^fg($COLOR_TITLE_FG)^bg($COLOR_TITLE_BG) ${line#?} ^bg()^fg()"
        #   ;;
        W*)
            # bspwm internal state
            wm_infos=""
            IFS=':'
            set -- ${line#?}

            # wm_infos="${wm_infos}^ca(1, bspc control --toggle-visibility )[ \` ]^ca()"
            # wm_infos="${wm_infos}^ca(1, zenity --question --text 'remove?' && bspc monitor --remove-desktops $(bspc query -d focused -D) )[ x ]^ca()"
            # wm_infos="${wm_infos}^ca(1, zenity --entry --text 'rename' | xargs --no-run-if-empty bspc desktop --rename )[ ~ ]^ca()"
            # wm_infos="${wm_infos}^ca(1, zenity --entry --text 'add' | xargs --no-run-if-empty bspc monitor --add-desktops )[ + ]^ca()"

            while [ $# -gt 0 ] ; do
                item=$1
                name=${item#?}
                case $item in
                    M*)
                        # active monitor
                        if [ $num_mon -gt 1 ] ; then
                            wm_infos="$wm_infos ^fg($COLOR_ACTIVE_MONITOR_FG)^bg($COLOR_ACTIVE_MONITOR_BG)^ca(1, bspc monitor --focus '${name}') ${name} ^ca()^bg()^fg() "
                        fi
                        ;;
                    m*)
                        # inactive monitor
                        if [ $num_mon -gt 1 ] ; then
                            wm_infos="$wm_infos ^fg($COLOR_INACTIVE_MONITOR_FG)^bg($COLOR_INACTIVE_MONITOR_BG)^ca(1, bspc monitor --focus '${name}') ${name} ^ca()^bg()^fg() "
                        fi
                        ;;
                    O*)
                        # focused occupied desktop
                        wm_infos="${wm_infos}^fg($COLOR_FOCUSED_OCCUPIED_FG)^bg($COLOR_FOCUSED_OCCUPIED_BG)^ca(1, bspc desktop --focus '${name}') ${name} ^ca()^bg()^fg()"
                        ;;
                    F*)
                        # focused free desktop
                        wm_infos="${wm_infos}^fg($COLOR_FOCUSED_FREE_FG)^bg($COLOR_FOCUSED_FREE_BG)^ca(1, bspc desktop --focus '${name}') ${name} ^ca()^bg()^fg()"
                        ;;
                    U*)
                        # focused urgent desktop
                        wm_infos="${wm_infos}^fg($COLOR_FOCUSED_URGENT_FG)^bg($COLOR_FOCUSED_URGENT_BG)^ca(1, bspc desktop --focus '${name}') ${name} ^ca()^bg()^fg()"
                        ;;
                    o*)
                        # occupied desktop
                        wm_infos="${wm_infos}^fg($COLOR_OCCUPIED_FG)^bg($COLOR_OCCUPIED_BG)^ca(1, bspc desktop --focus '${name}') ${name} ^ca()^bg()^fg()"
                        ;;
                    f*)
                        # free desktop
                        wm_infos="${wm_infos}^fg($COLOR_FREE_FG)^bg($COLOR_FREE_BG)^ca(1, bspc desktop --focus '${name}') ${name} ^ca()^bg()^fg()"
                        ;;
                    u*)
                        # urgent desktop
                        wm_infos="${wm_infos}^fg($COLOR_URGENT_FG)^bg($COLOR_URGENT_BG)^ca(1, bspc desktop --focus '${name}') ${name} ^ca()^bg()^fg()"
                        ;;
                    L*)
                        # layout
                        wm_infos="$wm_infos ^fg($COLOR_LAYOUT_FG)^bg($COLOR_LAYOUT_BG)^ca(1, bspc desktop --layout next) ${name} ^ca()^bg()^fg()"
                        ;;
                esac
                shift
            done
            ;;
    esac

    # wm_infos="${wm_infos} [h$(cat "${WINDOW_STACK}" | wc -l)] " 
    # wm_infos="${wm_infos} ^ca(1, /home/morock/bin/dzen_menu.sh)[h$(cat "${WINDOW_STACK}" | wc -l)]^ca() " 

    echo "${wm_infos}"
done
