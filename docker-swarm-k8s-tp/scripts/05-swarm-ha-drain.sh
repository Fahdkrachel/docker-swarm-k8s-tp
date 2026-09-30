#!/usr/bin/env bash
# Simule une maintenance du nœud worker : bascule ses tâches vers
# le manager, puis les réactive et rééquilibre.
#
# Usage (sur vm1, manager) :
#   bash 05-swarm-ha-drain.sh <nom_du_noeud_worker>

set -euo pipefail

WORKER="${1:-}"
if [[ -z "$WORKER" ]]; then
  echo "Usage: $0 <nom_du_noeud_worker>"
  echo "Trouvez le nom exact avec : docker node ls"
  exit 1
fi

echo "==> Mise en maintenance (drain) de ${WORKER}"
docker node update --availability drain "${WORKER}"
docker node ls
docker service ps swarm1

read -rp "Appuyez sur Entrée pour réactiver le nœud..." _

echo "==> Fin de maintenance : réactivation de ${WORKER}"
docker node update --availability active "${WORKER}"
docker service update --force swarm1
docker service ps swarm1
