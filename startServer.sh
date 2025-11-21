#!/bin/bash
set -eux pipefail

# Configure static IP on eth0
# ip addr flush dev eth0
# ip addr add 192.168.56.110/24 dev eth0
# ip link set eth0 up
# ip route add default via 192.168.56.1 dev eth0 || true

# Install curl, vim, ssh, python3
apt-get update && apt-get install -y curl vim openssh-server openssh-client openssl python3

# Make sure ssh service is enabled and running
systemctl enable ssh
systemctl start ssh

#create a token for k3s
K3S_TOKEN=$(openssl rand -hex 16)

# Install k3s as server/controller
curl -sfL https://get.k3s.io | K3S_TOKEN=$K3S_TOKEN sh -s - server --write-kubeconfig-mode 644 --node-ip $CONTROLLER_IP --flannel-iface eth1

# Install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# Clone the Helm chart from GitHub (optional - uncomment if using Git)
# git clone https://github.com/YOUR_USERNAME/inceptionOfThings.git /home/vagrant/charts
# Or use Helm repo (if you publish to a Helm repository)
# helm repo add myrepo https://YOUR_USERNAME.github.io/helm-charts
# helm repo update

# Expose token via HTTP for worker node
mkdir -p /k3s_token_share
echo "$K3S_TOKEN" > /k3s_token_share/node-token
chmod 644 /k3s_token_share/node-token

# Start simple HTTP server in background to serve the token
nohup python3 -m http.server 8000 --directory /k3s_token_share > /dev/null 2>&1 &

# Verify k3s is running
kubectl get nodes

echo "K3s controller setup complete. Token served at http://192.168.56.110:8000/node-token"

