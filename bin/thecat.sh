#!/bin/bash

f=3 b=4
for j in f b; do
  for i in {0..7}; do
    printf -v $j$i %b "\e[${!j}${i}m"
  done
done
bld=$'\e[1m'
rst=$'\e[0m'
inv=$'\e[7m'

#gtkrc="$HOME/.gtkrc-2.0"
#GtkTheme=$( grep "gtk-theme-name" "$gtkrc" | cut -d\" -f2 )
#GtkIcon=$( grep "gtk-icon-theme-name" "$gtkrc" | cut -d\" -f2 )
#GtkFont=$( grep "gtk-font-name" "$gtkrc" | cut -d\" -f2 )

# Wallpaper set by feh
# Wallpaper=$(cat /home/hokage/.fehbg | cut -c 16-70)

# Settings from ~/.Xdefaults
xdef="~/.Xdefaults"
TermFont="Monospace 12"

# Time and date
time=$( date "+%I.%M")
date=$( date "+%a %d %b" )

# OS
OS=$(uname -r -o -m)

# WM version
#AwVer=$(subtle --version | head -1 | cut -d' ' -f2 | sed 's/debian\///g' )

# Other
UPT=`uptime | awk -F'( |,)' '{print $2}' | awk -F ":" '{print $1}'`
uptime=$(uptime | sed 's/.*up \([^,]*\), .*/\1/')
uptime2=$(uptime | sed -nr 's/.*\s+([[:digit:]]{1,2}):[[:digit:]]{2},.*/\1/p')
size=$(df | grep '^/dev/[hs]d' | awk '{s+=$2} END {printf("%.0f\n", s/1048576)}')
use=$(df | grep '^/dev/[hs]d' | awk -M '{s+=$3} END {printf("%.0f\n", s/1048576)}')
gb=$(echo "G")
pac=$(pacman -Qe | wc -l)
pacman=$(pacman -Q | wc -l)
dist=$(cat /etc/issue | sed 's/ /n/')
COUNT=$(cat /proc/cpuinfo | grep 'model name' | sed -e 's/.*: //' | wc -l)
#laptop=$(dmidecode | grep Product)
laptop2=$(echo "Lenovo Ideapad z470") #dmidecode kudu pake sudo :hammers

cat << EOF   
$bld                                           
$f7                                                  
$f7                    .c0N.   .'c.                  $H the$f1 cat
$f7         'Okdl:'  ;OMMMMKOKNMMW:;o0l  .'.          
$f7         ;MMMMMMWWMMMMMMMMMMMMMMMMMXKWMMK         $H $f4$time$NC - $f7$date
$f7         'MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMK         $f6 $USER $f7@ $f1$HOSTNAME
$f7          NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO          
$f7          dMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:          GTK Theme »$f4 $GtkTheme$NC
$f7          'MMMMMMMMMMMMMMMMMMMMMMMMMMMMM.          GTK Icons »$f4 $GtkIcon$NC
$f7          'MMMMMMMMMMMMMMMMMMMMMMMMMMMMM;          GTK Font  »$f4 $GtkFont$NC
$f7          lMMMMM  MMMMMMMMMM  MMMMMMMMMM,          Term Font »$f4 $TermFont$NC
$f7          KMMMMM  MMMMMMMMMM  MMMMMMMMMM.          Uptime    »$f4 $uptime $uptime2 hours
$f7         ;WMMMMMkNMMMMMMMMMMONMMMMMMMMMW:          SSD       »$f4 $f2$use$f4 / $size$gb
$f7       oNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO         Packages  »$f2 $pacman
$f7      .,cxKWMMMMMMMMMMMMMMMMMMMMMMMMMMMXdxo        
$f7         ;kWMMMMMMMMMMMMMMMMMMMMMMMMMMMM:          
$f7        .::,  .;ok0NMMMMWNK0kdoc;'  'cxK0          
$f1                   .:cc:;;.                        OS »$f4 $OS$NC
$f1                   .o0MMMK'                        WM »$f4 i3 4.6
$f1                     xMMM:                         @  »$f7 Arch Linux
$f1                     KMMMl                         
$f1                    .MMMMo                        
$f1                    ,MMMMx                        
$f1                    oMMMMx                        
$f1                    OMMMMO                        
$f1                    .OMMMd                        
$f1                      :Nl       

EOF
