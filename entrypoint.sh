#!/usr/bin/env sh
set -e

# Dummy HTTP server to prevent Render from shutting down
echo "Starting dummy HTTP server..."
exec python3 -m http.server 8080
