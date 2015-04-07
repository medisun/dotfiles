#!/bin/bash

if ! [ "$1" ]
then
	echo 'Please set process name as argument'
else
for (( ; ; ))
	do
		if ! [ "$(ps aux | grep $1 | awk '{print $2}' | wc -l)" != '3' ]
		then
			echo `date +%T`
			$1
		fi
		`sleep 60s`
	done
fi

exit 0
