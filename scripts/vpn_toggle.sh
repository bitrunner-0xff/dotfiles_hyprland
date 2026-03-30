#!/usr/bin/env bash

IFACE="wg_ro"
if ip link show "$IFACE" | grep -q UP; then
    sudo wg-quick down "$IFACE"
    notify-send -i offline "VPN is Off"
else
    sudo wg-quick up "$IFACE"
    notify-send -i online "VPN is On"
fi
