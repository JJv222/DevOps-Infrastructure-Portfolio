#!/bin/bash

set -e
MACHINE_IP="localhost"
REGISTRY="192.168.56.200:5000"
TIMESTAMP=$(date +"%Y-%m-%d--%H-%M-%S")
TIMESTAMP_FRONTEND=$(date +"%Y-%m-%d")

REPO_URL="https://oauth2:${GITHUB_PAT}@github.com/JA263855"
FRONTEND_URL="$REPO_URL/frontend.git"
BACKEND_URL="$REPO_URL/backend.git"

REPO_DIR="/home/vagrant/build/repo"

echo "=== Download Projects from Repositories ==="
echo "===> Cleaning repo folder"
rm -rf "$REPO_DIR"
mkdir -p "$REPO_DIR"

echo "===> Cloning backend"
git clone "$BACKEND_URL" "$REPO_DIR/backend"

echo "===> Cloning frontend"
git clone -b jenkins-agent "$FRONTEND_URL" "$REPO_DIR/frontend"

echo "=== Building Local Docker images ==="
echo ">>> Building BACKEND..."
docker build -t cinema-backend:latest "$REPO_DIR/backend"
echo ">>> Building FRONTEND..."
docker build -t cinema-frontend:latest "$REPO_DIR/frontend"
# echo ">>> Building DATABASE..."
# docker build -t cinema-postgres:latest /vagrant/application/database

echo "=== Running Local Docker Compose ==="
bash "$(dirname "$0")/deploy-compose.sh"
echo "=== Smoke tests ==="
sleep 30
if [ "$(curl -fsS "$MACHINE_IP:8091" 2>/dev/null | grep -oP '(?<=<title>).*?(?=</title>)' || true)" = "Frontend" ]; then
  echo ">>> Frontend OK"
else
  echo ">>> Frontend does not respond or wrong title"
  cd "$(dirname "$0")/docker-compose"
  docker compose rm -sf 
  exit 1
fi

if curl -s "$MACHINE_IP:8090/api/film/repertoire?date=$TIMESTAMP_FRONTEND" | grep -q '"title":"The Matrix"'; then
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