#!/bin/sh

STATUS=$(nordvpn status | grep Status | tr -d ' ' | cut -d ':' -f2)

if [ "$STATUS" = "Connected" ]; then
    echo "%{F#00FF00}%{A1:nordvpn d:} %{A}%{F-}"
    #echo "VPN:%{F#00FF00}%{A1:nordvpn d:}$(nordvpn status | grep City | cut -d ':' -f2) %{A}%{F-}―$(nordvpn status | grep IP | cut -d ':' -f2) "
else
    #echo "VPN: %{F#f00}%{A1:nordvpn c:}Disconnected %{A}%{F-}"
    echo "%{F#f00}%{A1:nordvpn c:} %{A}%{F-}"
fi

