#!/usr/bin/env bash
low_power=10

while [ true ]; do
    if (($(cat /sys/class/power_supply/BAT0/capacity) <= $low_power)) &&
        [[ $(cat /sys/class/power_supply/BAT0/status) == Discharging ]]; then
        notify-send -u critical -i battery-empty "Battery" " \< 10%"
    fi
    sleep 30
done
