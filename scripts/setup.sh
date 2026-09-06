#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

echo "=== Home Nextcloud Setup ==="
echo

if ! command -v docker >/dev/null 2>&1; then
    echo "ERROR: Docker is not installed."
    exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
    echo "ERROR: Docker Compose is not available."
    exit 1
fi

mkdir -p storage/db
mkdir -p storage/data

if [ ! -f .env ]; then
    cp .env.example .env
    echo ".env created."
    echo
    echo "Edit it before starting:"
    echo "  nano .env"
else
    echo ".env already exists."
fi

echo
echo "Created:"
echo "  $PROJECT_DIR/storage/db"
echo "  $PROJECT_DIR/storage/data"
echo
echo "Setup complete."
