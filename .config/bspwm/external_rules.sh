#! /bin/sh

# use this command to 
# xprop | grep 'WM'

# WM_WINDOW_ROLE(STRING) = "browser"
# WM_CLASS(STRING) = "Navigator", "Firefox"
# WM_NAME(STRING) = "Sitename - Mozilla Firefox"

wid=$1
class=$2
instance=$3
role=$(/usr/bin/xprop -id "${wid}" 'WM_WINDOW_ROLE' | grep --color=never -Eo '".+' | rev | cut -c2- | rev | cut -c2-)
title=$(/usr/bin/xtitle "${wid}")

# echo '' >> '/tmp/wininfo'
# echo 'role ' $role >> '/tmp/wininfo'
# echo 'class ' $class >> '/tmp/wininfo'
# echo 'instance ' $instance >> '/tmp/wininfo'
# echo 'title ' $title >> '/tmp/wininfo'

case "$class" in
    "ncmpcpp_gui") echo 'state=floating border=off' ;;
    "OWASP") echo 'desktop=zap' ;;

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

        "Browser") case $(echo "$title" | cut -c-5) in
            "About") echo 'state=floating';;
        esac ;;

        "Scrapbook") case "$role" in
            "Scrapbook") echo 'state=floating';;
        esac ;;

    esac
    echo 'locked=on';;

    "Thunderbird") case "$instance" in
            "Mailnews")   echo 'state=floating';;
            "Msgcompose") echo 'desktop=email state=floating locked=on';;
            "Navigator")  echo 'desktop=email state=floating ';;
                  "Mail") echo 'desktop=email split_dir=south split_ratio=0.5 locked=on';;
    esac
    # /home/morock/bin/desktop.sh 'chat' '2'
    echo 'desktop=email split_dir=north'
    ;;

    "Skype") case "$instance" in
        "skype") case "$role" in
            "ConversationsWindow") echo 'split_dir=west split_ratio=0.75';;
                     "CallWindow") echo 'state=floating sticky=on';;

            *) case $(echo "$title" | cut -c-11) in
                    "Options") echo 'state=floating';;
                "Are you sur") echo 'state=floating';;
                "Add a Skype") echo 'state=floating';;
                "File Transf") echo 'split_dir=south split_ratio=0.8';;
                "Information") echo 'state=floating';;
                "Profile for") echo 'state=floating';;
                "Add people") echo 'state=floating';;
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

    "chromium"|"Chromium")
        case "$role" in
            'pop-up') echo 'state=floating';;
        esac
        case $(echo "$title" | cut -c-15) in
            "Developer Tools") echo 'floating=off split_dir=south split_ratio=0.4';;
        esac
        case $(echo "$title" | cut -c-8) in
            "Hangouts") echo 'state=floating';;
        esac
        
        echo 'desktop=chrome border=on'
    ;;

    "Terminator") case "$title" in
        'Terminator Preferences') echo 'state=floating';;
    esac
    ;;
esac


# ROLE GtkFileChooserDialog
