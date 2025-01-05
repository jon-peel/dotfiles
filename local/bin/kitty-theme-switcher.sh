#!/bin/bash
# ~/.local/bin/kitty-theme-switcher.sh

# Get current theme
current_theme=$(gsettings get org.gnome.desktop.interface color-scheme)

if [[ $current_theme == "'prefer-dark'" ]]; then
    kitty @ set-colors --all --configured ~/.config/kitty/solarized-dark.conf
else
    kitty @ set-colors --all --configured ~/.config/kitty/solarized-light.conf
fi
