#!/usr/bin/env bash
# Prépare une VM Ubuntu Server : installation de Docker Engine
# et ajout de l'utilisateur courant au groupe docker.
#
# Usage (sur vm1 ET sur vm2) :
#   bash 01-setup-vm.sh

set -euo pipefail

echo "==> Mise à jour des paquets"
sudo apt-get update

echo "==> Installation de Docker Engine"
curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
sudo sh /tmp/get-docker.sh

echo "==> Ajout de l'utilisateur courant au groupe docker"
sudo usermod -aG docker "$USER"

echo "==> Vérification"
docker --version || true
sudo docker run --rm hello-world

echo
echo "IMPORTANT : déconnectez-vous puis reconnectez-vous (exit + ssh)"
echo "pour utiliser Docker sans sudo."
echo
echo "Adresse IP de cette machine :"
ip -br a | grep -v '^lo'
