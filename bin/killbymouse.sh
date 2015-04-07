#!/bin/bash

kill -9 $(xprop | grep PID | cut -c25-)

exit 0
