#! /bin/sh

wid=$1
class=$2
instance=$3
role=$(/usr/bin/xprop -id "${wid}" 'WM_WINDOW_ROLE' | grep --color=never -Eo '".+' | rev | cut -c2- | rev | cut -c2-)
title=$(/usr/local/bin/xtitle "${wid}")

echo '' >> '/tmp/wininfo'
echo 'role ' $role >> '/tmp/wininfo'
echo 'class ' $class >> '/tmp/wininfo'
echo 'instance ' $instance >> '/tmp/wininfo'
echo 'title ' $title >> '/tmp/wininfo'

case "$class" in
    "Firefox") case "$instance" in

        "Dialog") case "$title" in
            "Request Progress")   echo 'desktop=req state=floating';;
            *)                    echo 'desktop=ff center=off follow=on focus=on border=off'; eval $(xdotool getmouselocation --shell); xdotool windowmove $wid $X $Y; unset X Y SCREEN WINDOW;;
        esac ;;

        "Navigator") case "$role" in
            "view-source")   echo 'desktop=ff split_dir=east split_ratio=0.5';;
            *)               echo 'desktop=ff';;
        esac ;;

        "SessionManager") case "$role" in
            "SessionPrompt") echo 'desktop=ff state=floating';;
        esac ;;

        "Firebug") case "$role" in
            "Detached")      echo 'desktop=ff split_dir=south split_ratio=0.75';;
        esac ;;

        "Devtools") case "$role" in
            "toolbox")       echo 'desktop=ff split_dir=east split_ratio=0.7';;
        esac ;;

        "Window") case "$role" in
            "httprequester") echo 'desktop=req';;
        esac ;;

        "Toplevel") case "$title" in
            "DOM Inspector") echo 'desktop=ff split_dir=east split_ratio=0.75';;
        esac ;;

        "Scrapbook") case "$role" in
            "Scrapbook") echo 'state=floating';;
        esac ;;

    esac
    echo 'state=locked';;

    "Thunderbird") case "$instance" in
            "Msgcompose") echo 'desktop=chat state=floating state=locked';;
            "Navigator")  echo 'desktop=chat state=floating ';;
                  "Mail") echo 'desktop=chat split_dir=south split_ratio=0.5 state=locked';;
    esac
    # /home/morock/bin/desktop.sh 'chat' '2'
    echo 'desktop=chat split_dir=north'
    ;;

    "Skype") case "$instance" in
        "skype") case "$role" in
            "ConversationsWindow") echo 'split_dir=west split_ratio=0.75';;
                     "CallWindow") echo 'state=floating state=sticky';;

            *) case $(echo "$title" | cut -c-11) in
                    "Options") echo 'state=floating';;
                "Are you sur") echo 'state=floating';;
                "File Transf") echo 'split_dir=south split_ratio=0.8';;
                "Information") echo 'state=floating';;
                "Profile for") echo 'state=floating';;
                            *) echo 'split_dir=east split_ratio=0.75';;
            esac ;;
        esac ;;
    esac
    # /home/morock/bin/desktop.sh 'chat' '2'
    echo 'desktop=chat'
    ;;

    "Gimp-2.8") case "$instance" in
        "gimp-2.8") case "$role" in
               "gimp-dock") echo 'split_dir=east split_ratio=0.85';;
            "gimp-toolbox") echo 'split_dir=east split_ratio=0.85';;
        esac
        # /home/morock/bin/desktop.sh 'gimp' '1'
        echo 'desktop=gimp';;
    esac ;;

    "Sublime_text") case "$instance" in
        "sublime_text")
            # /home/morock/bin/desktop.sh 'dev' '1'
            echo 'desktop=dev'
    esac ;;

    "chromium")
        case "$role" in
            'pop-up') echo 'state=floating';;
        esac
        case $(echo "$title" | cut -c-15) in
            "Developer Tools") echo 'floating=off split_dir=south split_ratio=0.4';;
        esac
        case $(echo "$title" | cut -c-8) in
            "Hangouts") echo 'state=floating';;
        esac
    echo 'desktop=chrome'
    ;;

    # WM_CLASS(STRING) = "terminator", "Terminator"
    # WM_ICON_NAME(STRING) = "Terminator Preferences"
    # _NET_WM_ICON_NAME(UTF8_STRING) = "Terminator Preferences"
    # WM_NAME(STRING) = "Terminator Preferences"
    # _NET_WM_NAME(UTF8_STRING) = "Terminator Preferences"


    "Terminator") case "$title" in
        'Terminator Preferences') echo 'state=floating';;
    esac
    ;;
esac


# ROLE GtkFileChooserDialog
