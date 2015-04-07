#!/bin/bash

##
# require xautomation, wmctrl packages
##

# Apps list
APPS[0]="Sublime Text"
APPS[1]="Mozilla Firefox"

# Actions list
ACTS[0]="'keydown Control_L' 'keydown Shift_L' 'key Tab' 'keyup Control_L' 'keyup Shift_L'"
ACTS[1]="'keydown Control_L' 'key Tab' 'keyup Control_L'"
ACTS[2]="'key Page_Down'"
ACTS[3]="'key Page_Up'"

# Lists count
NAPPS=${#APPS[*]}
NACTS=${#ACTS[*]}

while :
do
  # Choose app && action
  APP=${APPS[$(($RANDOM % $NAPPS))]}
  ACT=${ACTS[$(($RANDOM % $NACTS))]}

  # Dump print
  TIME="date +'%d %b  %H:%M'"
  echo $APP' - '$ACT

  # Switch to app
  eval 'wmctrl -a '$APP
  # Do the action
  eval 'xte '$ACT

  # Idle timeout
  sleep 120
done

exit 0
