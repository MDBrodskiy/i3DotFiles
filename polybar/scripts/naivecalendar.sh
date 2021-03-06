#!/bin/bash

param="$@"
cmd="${BASH_SOURCE%/*}/naivecalendar.py $param"

if [[ " ${param[@]} " =~ " -h " ]] || [[ " ${param[@]} " =~ " --help " ]] ; then
    $cmd
    exit 0
fi

THEME_CACHE_FILE="$HOME/.cache/naivecalendar/theme_cache.txt"
if test -f "$THEME_CACHE_FILE"; then
    THEME="${BASH_SOURCE%/*}/themes/$(cat $THEME_CACHE_FILE).rasi"
else
    #THEME="${BASH_SOURCE%/*}/themes/default.rasi"
    THEME="/usr/share/rofi/themes/Calendar.rasi"
fi
if [[ " ${param[@]} " =~ " -t " ]] || [[ " ${param[@]} " =~ " --theme " ]] ; then
    while [[ $# -gt 0 ]] ; do
        key="$1"
        case $key in
            -t|--theme)
            THEME="$2"
            shift # past argument
            shift # past value
            ;;
        esac
    done
    THEME="${BASH_SOURCE%/*}/themes/$THEME.rasi"
fi

rofi -show calendar \
    -modi "calendar:$cmd" \
    -font "DejaVuSansMono Nerd Font Bold 11" \
    -theme $THEME \
    -hide-scrollbar true \
    -x-offset 0 \
    -y-offset 55 \
    -location 3 \


if [[ " ${param[@]} " =~ " -p " ]] || [[ " ${param[@]} " =~ " --print " ]]; then
    FILE="$HOME/.cache/naivecalendar/pretty_print_cache.txt"
    cat $FILE
fi

