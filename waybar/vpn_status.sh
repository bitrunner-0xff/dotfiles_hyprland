#!/bin/bash

if ip l | grep wg | grep -q UP; then
    echo '{"text": "", "class": "vpn-on"}'
else
    echo '{"text": "", "class": "vpn-off"}'
fi
