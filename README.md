# Browser Select

A simple tool to choose which browser to open a URL with on Linux. It scans your system for installed browsers, caches the results for performance, and presents a selection menu using `zenity`.

## Features
- **Auto-detection**: Automatically finds browsers installed on your system by scanning `.desktop` files.
- **Caching**: Stores detected browsers in `~/.config/browser-select/browsers.txt` to ensure fast startup without re-scanning.
- **Native UI**: Uses `zenity` to provide a clean, graphical selection dialog.

## Usage
Run the script with a URL as the first argument:
```bash
./script.sh "https://www.example.com"
```

To manually refresh the cached browser list (e.g., after installing a new browser):
```bash
./script.sh --refresh
```

## Note: Original Hardcoded Browsers
The following browsers were previously hardcoded in the script before the auto-detection feature was added:
- **Brave**: `/usr/bin/brave-browser`
- **Google Chrome**: `google-chrome`
- **Vivaldi**: `vivaldi`
- **Firefox**: `firefox`
- **Ghostery**: `ghostery`

## Requirements
- `zenity` (usually pre-installed on GNOME-based systems like Ubuntu)
- Bash environment

## Installation
Ensure the script is executable:
```bash
chmod +x script.sh
```
