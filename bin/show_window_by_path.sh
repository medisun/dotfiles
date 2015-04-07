#!/usr/bin/env bash

pid=$(pidof -x -s ${1} | head -n 1)

if [ ! -z "$pid" ]; then
  
   wid=$(wmctrl -l -p | grep $pid | head -n1 | cut -c 1-10)

   if [ ! -z "$wid" ]; then
     wmctrl -i -a $wid
   fi
fi
