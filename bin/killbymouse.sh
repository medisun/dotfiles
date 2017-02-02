#!/bin/bash

# kill -9 $(xprop | grep PID | cut -c25-)
wmctrl -c :SELECT:

exit 0
