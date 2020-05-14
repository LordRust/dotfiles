#!/bin/bash
freemem="$(free | grep Mem | awk '{ printf("%.1f\n", $3/$2 * 100.0) }' )"
#up="$(uptime| cut -d" " -f4-|cut -d, -f1)"
echo "${freemem}"% RAM used
