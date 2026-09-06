#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

if [ ! -f .env ]; then
    echo "ERROR: .env not found."
    echo "Run ./scripts/setup.sh first."
    exit 1
fi

mkdir -p storage/db storage/data

docker compose up -d

echo
docker compose ps

PORT="$(grep '^NEXTCLOUD_PORT=' .env | cut -d= -f2)"
IP="$(hostname -I | awk '{print $1}')"

echo
echo "Nextcloud:"
echo "  Local: http://localhost:${PORT}"

if [ -n "${IP}" ]; then
    echo "  LAN:   http://${IP}:${PORT}"
fi
