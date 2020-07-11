#!/bin/sh

if [ "$(pgrep openvpn)" ]; then
    #tput setaf 2; echo "VPN"; tput sgr0
    echo "VPN: "
else
    #tput setaf 1; echo "VPN"; tput sgr0
    echo "VPN: off "
fi

