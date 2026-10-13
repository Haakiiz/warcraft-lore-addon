#!/bin/sh
# Render an HTML file in this folder to PNG with headless Chrome.
# Usage: sh .kritikk/wc2ui/render.sh <file.html> <out.png> <width> <height>
dir=$(cd "$(dirname "$0")" && pwd -W 2>/dev/null || pwd)
"/c/Program Files/Google/Chrome/Application/chrome.exe" --headless=new --disable-gpu --hide-scrollbars \
  --force-device-scale-factor=1 --window-size="$3,$4" --virtual-time-budget=4000 \
  --screenshot="$dir/$2" "file:///$dir/$1" 2>/dev/null
ls -la "$dir/$2"
