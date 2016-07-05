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
        #   sys_infos="<span foreground=\"$COLOR_STATUS_FG\" background=\"$COLOR_STATUS_BG\"> ${line#?} ^bg()fg()"
        #   ;;
        # T*)
        #   # xtitle output
        #   title="<span foreground=\"$COLOR_TITLE_FG\" background=\"$COLOR_TITLE_BG\"> ${line#?} ^bg()fg()"
        #   ;;
        W*)
            # bspwm internal state
            wm_infos=""
            IFS=':'
            set -- ${line#?}

            while [ $# -gt 0 ] ; do
                item=$1
                name=${item#?}
                case $item in
                    M*)
                        # active monitor
                        if [ $num_mon -gt 1 ] ; then
                            wm_infos="$wm_infos <span foreground=\"$COLOR_ACTIVE_MONITOR_FG\" background=\"$COLOR_ACTIVE_MONITOR_BG\"> ${name} </span>"
                        fi
                        ;;
                    m*)
                        # inactive monitor
                        if [ $num_mon -gt 1 ] ; then
                            wm_infos="$wm_infos <span foreground=\"$COLOR_INACTIVE_MONITOR_FG\" background=\"$COLOR_INACTIVE_MONITOR_BG\"> ${name} </span>"
                        fi
                        ;;
                    O*)
                        # focused occupied desktop
                        wm_infos="${wm_infos}<span foreground=\"$COLOR_FOCUSED_OCCUPIED_FG\" background=\"$COLOR_FOCUSED_OCCUPIED_BG\"> ${name} </span>"
                        ;;
                    F*)
                        # focused free desktop
                        wm_infos="${wm_infos}<span foreground=\"$COLOR_FOCUSED_FREE_FG\" background=\"$COLOR_FOCUSED_FREE_BG\"> ${name} </span>"
                        ;;
                    U*)
                        # focused urgent desktop
                        wm_infos="${wm_infos}<span foreground=\"$COLOR_FOCUSED_URGENT_FG\" background=\"$COLOR_FOCUSED_URGENT_BG\"> ${name} </span>"
                        ;;
                    o*)
                        # occupied desktop
                        wm_infos="${wm_infos}<span foreground=\"$COLOR_OCCUPIED_FG\" background=\"$COLOR_OCCUPIED_BG\"> ${name} </span>"
                        ;;
                    f*)
                        # free desktop
                        wm_infos="${wm_infos}<span foreground=\"$COLOR_FREE_FG\" background=\"$COLOR_FREE_BG\"> ${name} </span>"
                        ;;
                    u*)
                        # urgent desktop
                        wm_infos="${wm_infos}<span foreground=\"$COLOR_URGENT_FG\" background=\"$COLOR_URGENT_BG\"> ${name} </span>"
                        ;;
                    L*) case ${name} in
                        # layout
                        T*) 
                            wm_infos="$wm_infos <span foreground=\"$COLOR_LAYOUT_FG\" background=\"$COLOR_LAYOUT_BG\"> ◱ </span>"
                            ;;
                        M*)
                            wm_infos="$wm_infos <span foreground=\"$COLOR_LAYOUT_FG\" background=\"$COLOR_LAYOUT_BG\"> ◻ </span>"
                            ;;
                        esac
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
