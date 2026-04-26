#!/bin/bash

# Configuration
CACHE_DIR="$HOME/.config/browser-select"
CACHE_FILE="$CACHE_DIR/browsers.txt"

# Function to refresh the browser list
refresh_browsers() {
    mkdir -p "$CACHE_DIR"
    
    # Temporary file to store results
    TEMP_FILE=$(mktemp)
    
    # Common locations for .desktop files
    DESKTOP_DIRS=("/usr/share/applications" "$HOME/.local/share/applications")
    
    for dir in "${DESKTOP_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            # Search for files that are categorized as WebBrowser
            # We filter out our own desktop file to avoid recursion
            grep -l "Categories=.*WebBrowser" "$dir"/*.desktop 2>/dev/null | grep -v "browser-select.desktop" | while read -r file; do
                # Extract Name
                NAME=$(grep "^Name=" "$file" | head -1 | cut -d'=' -f2)
                
                # Only add if we have a name and it's a valid desktop file
                if [ -n "$NAME" ]; then
                    echo "$NAME|$file" >> "$TEMP_FILE"
                fi
            done
        fi
    done

    # Sort and remove duplicates based on name, then save to cache
    if [ -s "$TEMP_FILE" ]; then
        sort -u -t'|' -k1,1 "$TEMP_FILE" > "$CACHE_FILE"
    else
        > "$CACHE_FILE"
    fi
    rm "$TEMP_FILE"
}

# If cache doesn't exist or --refresh is passed, refresh it
if [ ! -f "$CACHE_FILE" ] || [ "$1" == "--refresh" ]; then
    refresh_browsers
    if [ "$1" == "--refresh" ]; then
        shift
        if [ -z "$1" ]; then
            echo "Browser list refreshed."
            exit 0
        fi
    fi
fi

# Read browsers from cache into arrays
NAMES=()
PATHS=()
while IFS='|' read -r name path; do
    if [ -n "$name" ]; then
        NAMES+=("$name")
        PATHS+=("$path")
    fi
done < "$CACHE_FILE"

# Exit if no browsers are found
if [ ${#NAMES[@]} -eq 0 ]; then
    zenity --error --text="No web browsers found. Try running with --refresh."
    exit 1
fi

# Create the selection menu
SELECTED_NAME=$(zenity --list --title="Select Browser" --column="Browser" --height=400 "${NAMES[@]}")

# If user cancels or closes window, exit
if [ -z "$SELECTED_NAME" ]; then
    exit 0
fi

# Find the desktop file path for the selected name
DESKTOP_PATH=""
for i in "${!NAMES[@]}"; do
    if [ "${NAMES[$i]}" == "$SELECTED_NAME" ]; then
        DESKTOP_PATH="${PATHS[$i]}"
        break
    fi
done

# Open the URL using gio launch
if [ -n "$DESKTOP_PATH" ]; then
    # gio launch handles the desktop file properly, respecting existing instances
    if [ -n "$1" ]; then
        gio launch "$DESKTOP_PATH" "$1" &
    else
        gio launch "$DESKTOP_PATH" &
    fi
    exit 0
else
    zenity --error --text="No browser selected or unrecognized option."
    exit 1
fi
