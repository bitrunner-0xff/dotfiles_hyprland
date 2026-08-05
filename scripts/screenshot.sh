#!/usr/bin/env bash

SCREENSHOT_DIR="$HOME/Screenshots"

[[ ! -e $SCREENSHOT_DIR ]] && mkdir -p $SCREENSHOT_DIR

FILE="$SCREENSHOT_DIR/$(date +%F_%T).png"

if [ "$1" = "--region" ]; then
    grim -g "$(slurp)" "$FILE"
else
    grim "$FILE"
fi

wl-copy <"$FILE"
