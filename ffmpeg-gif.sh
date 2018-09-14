#!/bin/sh

palette="$1.palette.png"

if [[ ! -e $palette ]]; then
    ffmpeg -y -i $1 -vf palettegen $palette
fi

filters="fps=15,scale=640:-1:flags=lanczos"

ffmpeg -v warning -i $1 -vf "$filters,palettegen=stats_mode=diff" -y $palette

ffmpeg -i $1 -i $palette -lavfi "$filters,paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle" -y $2
