#!/bin/bash
FILENAME="screenshot-`date +%F-%T`"
grim -g "$(slurp)" /home/aryan/Pictures/screenshots/FILENAME.png
