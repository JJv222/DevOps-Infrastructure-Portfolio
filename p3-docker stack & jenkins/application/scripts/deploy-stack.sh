#!/bin/bash
set -e

STACK_NAME="cinema"

# katalog z docker-stack.yml i .env
cd "$(dirname "$0")/docker-stack"

# Usuń windowose znaki 
sed -i 's/\r$//' .env
# Załaduj zmienne z .env (jeśli jest)
export $(cat .env) > /dev/null 2>&1

echo "[INFO] Deploy stack '$STACK_NAME' z pliku docker-stack.yml..."
docker stack deploy -c docker-stack.yml "$STACK_NAME"

echo "[INFO] Stack wdrożony. Serwisy w stacku:"
docker stack services "$STACK_NAME"
echo "[INFO] Oczekiwanie na uruchomienie serwisów..."
sleep 10
echo "[INFO] Sprawdzanie statusu serwisów..."
docker stack ps "$STACK_NAME"