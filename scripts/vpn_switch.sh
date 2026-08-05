#!/usr/bin/env bash

vpns=$(ls /etc/wireguard/)
flag=0

for vpn in $vpns; do
    vpnname="${vpn%.*}"
    if [ $flag == 1 ] || ! $(ip l | grep wg | grep -q UP); then
        echo "$vpnname $vpns"
        sudo wg-quick up $vpnname
        notify-send -i online "Wireguard" "Enable $vpnname VPN."
        exit 0
    fi
    if ip l | grep -q $vpnname; then
        sudo wg-quick down $vpnname
        flag=1
    fi
done

notify-send -i offline "Wireguard" "Disable VPN!"
exit 0
