#!/bin/bash

# Define your browsers
BROWSERS=("Firefox" "Google Chrome" "Chromium" "Opera")

# Create the selection menu
BROWSER=$(zenity --list --title="Select Browser" --column="Browser" "${BROWSERS[@]}")

# Open the URL in the selected browser
case $BROWSER in
    "Firefox")
        firefox "$1"
        ;;
    "Google Chrome")
        google-chrome "$1"
        ;;
    "Chromium")
        chromium "$1"
        ;;
    "Opera")
        opera "$1"
        ;;
    *)
        echo "No browser selected or unrecognized option."
        exit 1
        ;;
esac
