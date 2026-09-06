#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

echo "=== Containers ==="
docker compose ps

echo
echo "=== Disk Space ==="
df -h "$PROJECT_DIR"

echo
echo "=== Nextcloud Staging Data ==="
du -sh storage/data 2>/dev/null || true

echo
echo "=== MariaDB Data ==="
du -sh storage/db 2>/dev/null || true

echo
echo "=== Nextcloud Status ==="
docker compose exec --user www-data nextcloud php occ status 2>/dev/null || true
