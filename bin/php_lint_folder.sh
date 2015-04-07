#!/bin/bash

echo $1 > /home/hasq/bin/out
find $1 -name "*.php" -exec php -l {} \;

exit 0
