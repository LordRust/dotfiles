#!/bin/bash
export DISPLAY="localhost:1.0"
xrdb -merge "$HOME/.Xresources"
exec /usr/bin/xterm -xrm "xterm*iconHint: $HOME/.local/os_logo.xpm"
