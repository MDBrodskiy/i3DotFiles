#!/bin/bash

#enter the following command in your ncmpcpp directory:
# convert -size 316x316 xc:none -draw "roundrectangle 0,0,316,316,20,20" mask.png && convert -size 300x300 xc:none -draw "roundrectangle 0,0,300,300,20,20" mask2.png

MUSIC_DIR=$HOME/Music

COVER=/tmp/cover.jpg

function reset_background
{

    #fetch default album cover from directory
    default=/home/Devuan/.config/ncmpcpp/default_cover.jpg

    #resize to fit screen
    #resize the image's width to 300px 
    convert "$default" -adaptive-resize 300x300 "$COVER"

    #place it 7% away from left and 90% away from top.
    printf "\e]20;${COVER};18x30+7+90\a"
    notify-send --icon=$COVER "$artist — $track"
}

{

    rm -f /tmp/Cover.png
    track="$(mpc --format %title% current)"
    artist="$(mpc --format %artist% current)"
    album="$(mpc --format %album% current)"
    file="$(mpc --format %file% current)"
    album_dir="${file%/*}"
    [[ -z "$album_dir" ]] && exit 1
    album_dir="$MUSIC_DIR/$album_dir"

    ffmpeg -loglevel quiet -i "/home/Devuan/Music/$file" /tmp/Cover.png

    #covers="$(find "$album_dir" -type d -exec find {} -maxdepth 1 -type f -iregex ".*/.*\(${album}\|cover\|folder\|artwork\|front\).*[.]\(jpeg\|jpg\|png\|gif\|bmp\)" \; )"
    covers=/tmp/Cover.png
    src="$(echo -n "$covers" | head -n1)"
    rm -f "$COVER" 
    if [ -f "$covers" ]; then
        if [[ -n "$src" ]] ; then
            #resize the image's width to 300px 
            convert "$src" -adaptive-resize 300x300 "$src"
            convert "$src" -matte /home/Devuan/.config/ncmpcpp/mask2.png -compose DstIn -composite "$src"
            convert "$src" -bordercolor "#00AA00" -border 8x8 "$src"
            convert "$src" -matte /home/Devuan/.config/ncmpcpp/mask.png -compose DstIn -composite "png:$COVER"
            #convert "$src" -resize 300x300 "$COVER"
            if [[ -f "$COVER" ]] ; then
                #scale down the cover to 30% of the original
                #place it 8% away from left and 90% away from top.
                printf "\e]20;${COVER};30x30+8+90:op=keep-aspect\a"
                notify-send --icon=$COVER "$artist — $track"
            fi
        fi
    else
        reset_background
    fi
} &
