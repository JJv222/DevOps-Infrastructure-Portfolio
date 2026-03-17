#!/bin/bash
set -e  # przerwij skrypt gdy coś pójdzie nie tak

cd "$(dirname "$0")/docker-compose"
sed -i 's/\r$//' .env

echo "[INFO] Buduję i uruchamiam aplikację przy użyciu docker compose..."
docker compose up -d --build

echo "[INFO] Gotowe. Sprawdź kontenery komendą: docker compose ps"
sleep 10
docker compose ps 
