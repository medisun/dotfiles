#! /bin/sh

wid=$1
class=$2
instance=$3
role=$(/usr/bin/xprop -id "${wid}" 'WM_WINDOW_ROLE' | grep --color=never -Eo '".+' | rev | cut -c2- | rev | cut -c2-)
title=$(/usr/local/bin/xtitle "${wid}")

# echo '' >> '/tmp/wininfo'
# echo 'role ' $role >> '/tmp/wininfo'
# echo 'class ' $class >> '/tmp/wininfo'
# echo 'instance ' $instance >> '/tmp/wininfo'
# echo 'title ' $title >> '/tmp/wininfo'

case "$class" in
    "Firefox") case "$instance" in

        "Dialog") echo 'desktop=web center=off follow=on focus=on border=off'; eval $(xdotool getmouselocation --shell); xdotool windowmove $wid $X $Y; unset X Y SCREEN WINDOW;;

        "Navigator") case "$role" in
            "view-source")   echo 'desktop=web split_dir=right split_ratio=0.5';;
        esac ;;

        "Firebug") case "$role" in
            "Detached")      echo 'desktop=web split_dir=down split_ratio=0.75';;
        esac ;;

        "Devtools") case "$role" in
            "toolbox")       echo 'desktop=web split_dir=right split_ratio=0.7';;
        esac ;;

        "Window") case "$role" in
            "httprequester") echo 'desktop=req';;
        esac ;;

        "Toplevel") case "$title" in
            "DOM Inspector") echo 'desktop=web split_dir=right split_ratio=0.75';;
        esac ;;

    esac 
    echo 'locked=on';;

    "Thunderbird") case "$instance" in
            "Msgcompose") echo 'desktop=chat floating=on';;
                  "Mail") echo 'desktop=chat split_dir=down split_ratio=0.5';;
    esac 
    echo 'locked=on split_dir=up' ;;

    "Skype") case "$instance" in
        "skype") case "$role" in
            "ConversationsWindow") echo 'split_dir=left split_ratio=0.75';;

            *) case $(echo "$title" | cut -c-11) in
                "File Transf") echo 'split_dir=down split_ratio=0.8';;
                "Information") echo 'floating=on';;
                "Profile for") echo 'floating=on';;
                            *) echo 'split_dir=right split_ratio=0.75';;
            esac ;;
        esac ;;
    esac ;;

    "Gimp") case "$instance" in
        "gimp") case "$role" in
               "gimp-dock") echo 'split_dir=right split_ratio=0.85';;
            "gimp-toolbox") echo 'split_dir=right split_ratio=0.85';;
        esac 
        /home/morock/bin/desktop.sh 'dev' '1'
        echo 'desktop=gimp';;
    esac ;;
esac
