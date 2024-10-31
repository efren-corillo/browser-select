#!/bin/bash

# Define possible browsers in a specific order
BROWSER_ORDER=("Brave" "Google Chrome" "Vivaldi" "Firefox" "Ghostery")

# Define the corresponding commands
declare -A BROWSERS
BROWSERS["Brave"]="/usr/bin/brave-browser"
BROWSERS["Google Chrome"]="google-chrome"
BROWSERS["Vivaldi"]="vivaldi"
BROWSERS["Firefox"]="firefox"
BROWSERS["Ghostery"]="ghostery"
# BROWSERS["Chromium"]="chromium-browser"
# BROWSERS["Opera"]="opera"

# Check for installed browsers in the specific order
INSTALLED_BROWSERS=()
for name in "${BROWSER_ORDER[@]}"; do
    command=${BROWSERS[$name]}
    if command -v $command &> /dev/null; then
        INSTALLED_BROWSERS+=("$name")
    fi
done

# Exit if no browsers are found
if [ ${#INSTALLED_BROWSERS[@]} -eq 0 ]; then
    zenity --error --text="No web browsers found."
    exit 1
fi

# Create the selection menu
BROWSER=$(zenity --list --title="Select Browser" --column="Browser" --height=400 "${INSTALLED_BROWSERS[@]}")

# Open the URL in the selected browser
BROWSER_COMMAND=${BROWSERS[$BROWSER]}
if [ -n "$BROWSER_COMMAND" ]; then
    $BROWSER_COMMAND "$1"
else
    zenity --error --text="No browser selected or unrecognized option."
    exit 1
fi
