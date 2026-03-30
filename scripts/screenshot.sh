#!/usr/bin/env bash

EXTERNAL="/run/media/veracrypt1"
#EXTERNAL="/mnt/veracrypt"
LOCAL="$HOME"

if [ -d "$EXTERNAL" ] && [ -w "$EXTERNAL" ]; then
    DEST="${EXTERNAL}/Screenshots"
else
    DEST="$LOCAL/Screenshots"
fi

mkdir -p "$DEST"

FILE="$DEST/$(date +%F_%T).png"

if [ "$1" = "--region" ]; then
    grim -g "$(slurp)" "$FILE"
else
    grim "$FILE"
fi

wl-copy <"$FILE"
