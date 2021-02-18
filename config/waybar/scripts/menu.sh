#!/bin/bash

entries="Launcher Display Apperance Power Printer Bluetooth Sound "

selected=$(printf '%s\n' $entries | wofi --conf=$HOME/.config/wofi/config.screenshot --style=$HOME/.config/wofi/style.widgets.css  | awk '{print tolower($1)}')

case $selected in
  launcher)
    exec wofi -c ~/.config/wofi/config -I;
  displays)
    exec wdisplays;;
  appereance)
    exec lxapperance;;
  power)
    exec wofi -c ~/.config/wofi/config -I;;
  printer)
   exec system-config-printer;;
  bluetooth)
   exec blueman-manager;;
  sound)
  exec pavucontrol;;
esac
