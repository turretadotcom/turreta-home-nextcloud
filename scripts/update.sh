#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

echo "Pulling updates within the pinned image tags..."
docker compose pull

echo
echo "Recreating containers..."
docker compose up -d

echo
docker compose ps

echo
echo "Done."
echo "Major Nextcloud upgrades should be done by explicitly changing"
echo "the image tag in compose.yaml."
