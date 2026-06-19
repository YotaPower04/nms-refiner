#!/usr/bin/env bash
# Serve the cheat sheet locally and open it in the default browser.
set -e
PORT="${1:-8080}"
cd "$(dirname "$0")"
echo "Serving NMS Refiner Cheat Sheet at http://localhost:$PORT"
xdg-open "http://localhost:$PORT" >/dev/null 2>&1 &
exec python3 -m http.server "$PORT"
