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
    "Firefox")
        case "$instance" in
            "Firebug")
                case "$role" in
                    "Detached")
                        echo 'split_dir=down split_ratio=0.75'
                    ;;
                esac
            ;;
            "Devtools")
                case "$role" in
                    "toolbox")
                        echo 'split_dir=right split_ratio=0.7'
                    ;;
                esac
            ;;
            "Window")
                case "$role" in
                    "httprequester")
                        echo 'desktop=req'
                    ;;
                esac
            ;;
        esac
        echo 'locked=on'
    ;;
    "Thunderbird")
        case "$instance" in
            "Mail")
                echo 'desktop=chat split_dir=down split_ratio=0.5'
            ;;
            "Msgcompose")
                echo 'desktop=chat floating=on'
            ;;
        esac
    ;;
    "Skype")
        case "$instance" in
            "skype")
                case "$role" in
                    "ConversationsWindow")
                        echo 'split_dir=left split_ratio=0.75'
                    ;;
                    *)
                        case $(echo "$title" | cut -c-11) in
                            "File Transf")
                                echo 'split_dir=down split_ratio=0.8'
                            ;;
                            "Information")
                                echo 'floating=on'
                            ;;
                            "Profile for")
                                echo 'floating=on'
                            ;;
                            *)
                                echo 'split_dir=right split_ratio=0.75'
                            ;;
                        esac
                    ;;
                esac
            ;;
        esac
    ;;
esac
