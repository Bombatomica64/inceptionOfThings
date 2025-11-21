#!/bin/bash
set -e

# Set KUBECONFIG for root user
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# This script will be synced to the VM and used to deploy the Helm chart

# Wait for k3s to be ready
echo "Waiting for k3s to be ready..."
until sudo kubectl get nodes &> /dev/null; do
  echo "Waiting for kubectl..."
  sleep 2
done

echo "Deploying Helm chart..."
sudo helm upgrade --install my-apps /home/vagrant/ex02/ex02 \
  --namespace default \
  --create-namespace \
  --wait

echo "Checking deployment status..."
sudo kubectl get pods -n default
sudo kubectl get svc -n default
sudo kubectl get ingress -n default

echo "Deployment complete!"
echo "Access the apps using:"
echo "  curl -H 'Host: app1.com' http://192.168.56.110"
echo "  curl -H 'Host: app2.com' http://192.168.56.110"
echo "  curl http://192.168.56.110  (default: app3)"
