#!/usr/bin/env bash
# Rattache ce nœud au cluster Swarm en tant que worker.
#
# Usage (sur vm2) :
#   bash 03-swarm-join.sh "docker swarm join --token SWMTKN-1-... <IP_VM1>:2377"

set -euo pipefail

JOIN_CMD="${1:-}"
if [[ -z "$JOIN_CMD" ]]; then
  echo "Usage: $0 \"<commande docker swarm join complète>\""
  exit 1
fi

echo "==> Rattachement au cluster"
eval "$JOIN_CMD"

echo
echo "==> Vérification locale"
docker info --format '{{.Swarm.LocalNodeState}}'
