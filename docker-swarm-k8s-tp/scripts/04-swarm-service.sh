#!/usr/bin/env bash
# Cycle de vie complet du service "swarm1" : build, création, publication,
# montée en charge, mise à jour et retour arrière.
#
# Usage (sur vm1, manager) :
#   bash 04-swarm-service.sh

set -euo pipefail
cd "$(dirname "$0")/../webapp"

echo "==> Build de l'image webapp:latest (V1)"
docker build -t webapp:latest .

echo "==> Build de l'image webapp:v2 (V2)"
sed -i 's/welcome bdcc V1/welcome bdcc V2/' index.html
docker build -t webapp:v2 .
sed -i 's/welcome bdcc V2/welcome bdcc V1/' index.html   # restaure le fichier source

echo "==> Création du service swarm1"
docker service create --name swarm1 webapp:latest

echo "==> Liste des services"
docker service ls

echo "==> Détails du service"
docker service ps swarm1
docker service inspect --pretty swarm1

echo "==> Publication du port 8080 -> 80"
docker service update --publish-add published=8080,target=80 swarm1

echo "==> Montée à 5 réplicas"
docker service scale swarm1=5
docker service ps swarm1

echo "==> Mise à jour progressive vers webapp:v2"
docker service update --update-parallelism 1 --update-delay 10s --image webapp:v2 swarm1
docker service ps swarm1

echo "==> Retour à la version précédente"
docker service rollback swarm1
docker service ps swarm1

echo
echo "Testez l'accès :"
echo "  curl http://<IP_VM1>:8080"
echo "  curl http://<IP_VM2>:8080"
echo
echo "Pour supprimer le service : docker service rm swarm1"
