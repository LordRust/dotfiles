#!/bin/bash
export DISPLAY="localhost:1.0"
export DISPLAY="$(ip route list default)"
export DISPLAY="${DISPLAY#default via }"
export DISPLAY="${DISPLAY%% *}:1.0"
#xrdb -cpp /usr/bin/cpp -merge "$HOME/.Xresources"
#xrdb -merge -I$HOME "$HOME/.Xresources"
xrdb -merge "$HOME/.Xresources"
exec /usr/bin/xterm -xrm "xterm*iconHint: $HOME/.local/os_logo.xpm"
#exec /usr/bin/xterm
