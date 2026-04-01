#!/usr/bin/env bash

IFACE="wg_ro"
if ip addr show "$IFACE" | grep -i UP; then
    sudo wg-quick down "$IFACE"
    notify-send -i offline "VPN is Off"
else
    sudo wg-quick up "$IFACE"
    notify-send -i online "VPN is On"
fi
