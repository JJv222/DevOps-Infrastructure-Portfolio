#!/bin/bash

set -e
MACHINE_IP="localhost"
REGISTRY="192.168.56.200:5000"
TIMESTAMP=$(date +"%Y-%m-%d--%H-%M-%S")
TIMESTAMP_FRONTEND=$(date +"%Y-%m-%d")

echo "=== Building Local Docker images ==="
echo ">>> Building BACKEND..."
docker build -t cinema-backend:latest ../backend
echo ">>> Building FRONTEND..."
docker build -t cinema-frontend:latest ../frontend
# echo ">>> Building DATABASE..."
# docker build -t cinema-postgres:latest ../database


echo "=== Running Local Docker Compose ==="
bash ./deploy-compose.sh
echo "=== Smoke tests ==="
sleep 30
if [ "$(curl -fsS "$MACHINE_IP" 2>/dev/null | grep -oP '(?<=<title>).*?(?=</title>)' || true)" = "Frontend" ]; then
  echo ">>> Frontend OK"
else
  echo ">>> Frontend does not respond or wrong title"
  cd "$(dirname "$0")/docker-compose"
  docker compose rm -sf 
  exit 1
fi

if curl -s "$MACHINE_IP/api/film/repertoire?date=$TIMESTAMP_FRONTEND" | grep -q '"title":"The Matrix"'; then
  echo ">>> Backend OK (Matrix found)"
else
  echo ">>> Backend does not respond / Matrix not found, stopping..."
  echo "Smoke test FAILED"
  cd "$(dirname "$0")/docker-compose"
  docker compose rm -sf 
  exit 1
fi
cd "$(dirname "$0")/docker-compose"
docker compose rm -sf 
cd "$(dirname "$0")"
echo ">>> Smoke tests passed."


echo "=== Pushing images to Local Registry ==="
echo ">>> Pushing images to registry $REGISTRY ..."
docker tag cinema-backend:latest $REGISTRY/cinema-backend:latest
docker tag cinema-backend:latest $REGISTRY/cinema-backend:$TIMESTAMP
docker push -a  $REGISTRY/cinema-backend

docker tag cinema-frontend:latest $REGISTRY/cinema-frontend:latest
docker tag cinema-frontend:latest $REGISTRY/cinema-frontend:$TIMESTAMP
docker push -a  $REGISTRY/cinema-frontend

# docker tag cinema-postgres:latest $REGISTRY/cinema-postgres:latest
# docker tag cinema-postgres:latest $REGISTRY/cinema-postgres:$TIMESTAMP
# docker push -a  $REGISTRY/cinema-postgres

echo "=== Checking registry content ==="
curl http://$REGISTRY/v2/_catalog
curl http://$REGISTRY/v2/cinema-backend/tags/list
curl http://$REGISTRY/v2/cinema-frontend/tags/list
# curl http://$REGISTRY/v2/cinema-postgres/tags/list
exit 0