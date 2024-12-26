#!/bin/bash

# Setup logging
LOG_FILE="./browser_select.log"  # Specify the path to your log file

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Load environment variables from .env file
if [ -f ".env" ]; then
    log "Loading environment variables from .env file"
    export $(grep -v '^#' .env | xargs)
else
    zenity --error --text=".env file not found!"
    log ".env file not found!"
    exit 1
fi

# Define the browser command pairs from the BROWSER_COMMANDS string
declare -A BROWSERS

# Parse the BROWSER_COMMANDS string into an associative array
IFS=',' read -ra BROWSER_ARRAY <<< "$BROWSER_COMMANDS"
for browser_pair in "${BROWSER_ARRAY[@]}"; do
    IFS=':' read -r browser_name browser_command <<< "$browser_pair"
    BROWSERS["$browser_name"]="$browser_command"
done
log "Parsed browser commands."

# Check for installed browsers in the specific order
INSTALLED_BROWSERS=()
for name in "${BROWSER_ORDER[@]}"; do
    command=${BROWSERS[$name]}
    if command -v $command &> /dev/null; then
        INSTALLED_BROWSERS+=("$name")
        log "$name browser is installed."
    else
        log "$name browser is not installed."
    fi
done

# Exit if no browsers are found
if [ ${#INSTALLED_BROWSERS[@]} -eq 0 ]; then
    zenity --error --text="No web browsers found."
    log "No web browsers found."
    exit 1
fi

# Create the selection menu
BROWSER=$(zenity --list --title="Select Browser" --column="Browser" --height=400 "${INSTALLED_BROWSERS[@]}")
log "Selected browser: $BROWSER"

# Open the URL in the selected browser
BROWSER_COMMAND=${BROWSERS[$BROWSER]}
if [ -n "$BROWSER_COMMAND" ]; then
    log "Opening URL with $BROWSER_COMMAND"
    $BROWSER_COMMAND "$1"
else
    zenity --error --text="No browser selected or unrecognized option."
    log "Failed to execute browser command or unrecognized browser."
    exit 1
fi