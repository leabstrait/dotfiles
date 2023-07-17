#!/bin/bash

killall conky 2>/dev/null

if [ "$1" = "-n" ]; then
    pause_flag=""
else
    pause_flag="--pause=5"
    echo "Conky waiting 5 seconds to start..."
fi

conky "$pause_flag" -c ~/.config/conky/general.conf.lua &
conky "$pause_flag" -c ~/.config/conky/sysinfo.conf.lua
