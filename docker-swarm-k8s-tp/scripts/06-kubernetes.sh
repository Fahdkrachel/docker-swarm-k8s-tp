#!/usr/bin/env bash
# Déploie, expose, scale puis nettoie l'application sur Kubernetes (Minikube).
#
# Usage (sur le poste hôte, minikube déjà démarré) :
#   bash 06-kubernetes.sh

set -euo pipefail
cd "$(dirname "$0")/../webapp"

echo "==> Build et chargement de l'image dans Minikube"
docker build -t webapp:v1 .
minikube image load webapp:v1

echo "==> Création du déploiement"
kubectl create deployment kubernetes1 --image=webapp:v1
kubectl get deployments
kubectl get pods

echo "==> Exposition du service"
kubectl expose deployment kubernetes1 --type=LoadBalancer --port=8080 --target-port=80
kubectl get services
kubectl describe services kubernetes1

echo "==> Montée à 3 réplicas"
kubectl scale --replicas=3 deployment kubernetes1
kubectl get pods

echo
echo "Accès au service : minikube service kubernetes1"
echo "Tableau de bord   : minikube dashboard"
echo
read -rp "Appuyez sur Entrée pour nettoyer (supprime service + déploiement)..." _

kubectl delete service kubernetes1
kubectl delete deployment kubernetes1
echo "==> Nettoyage terminé"
