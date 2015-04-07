#!/bin/bash

scrot '%Y-%m-%d--%s_$wx$h_scrot.png' -e 'mv $f ~/images/ & notify-send $f'
