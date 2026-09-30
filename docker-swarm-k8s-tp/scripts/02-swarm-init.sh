#!/usr/bin/env bash
# Initialise le nœud manager du cluster Swarm.
#
# Usage (sur vm1) :
#   bash 02-swarm-init.sh <IP_VM1>

set -euo pipefail

IP_VM1="${1:-}"
if [[ -z "$IP_VM1" ]]; then
  echo "Usage: $0 <IP_VM1>"
  echo "Exemple: $0 192.168.1.11"
  exit 1
fi

echo "==> Initialisation du cluster Swarm sur ${IP_VM1}"
docker swarm init --advertise-addr "${IP_VM1}"

echo
echo "==> Nœuds actifs"
docker node ls

echo
echo "Copiez la commande 'docker swarm join --token ...' ci-dessus"
echo "et exécutez-la sur vm2 avec 03-swarm-join.sh"
