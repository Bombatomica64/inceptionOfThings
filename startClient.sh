#!/bin/bash
set -eux pipefail

# Configure static IP on eth0
# ip addr flush dev eth0
# ip addr add 192.168.56.111/24 dev eth0
# ip link set eth0 up
# ip route add default via 192.168.56.1 dev eth0 || true

# Install curl, vim, ssh
apt-get update && apt-get install -y curl vim openssh-server openssh-client

# Make sure ssh service is enabled and running
systemctl enable ssh
systemctl start ssh

# Wait for controller to be ready and token to be available
echo "Waiting for controller token..."
for i in {1..300}; do
  if curl -s -f http://$CONTROLLER_IP:8000/node-token -o /tmp/node-token; then
    echo "Token found!"
    break
  fi
  echo "Waiting for token... ($i/300)"
  sleep 2
done

if [ ! -f /tmp/node-token ]; then
  echo "ERROR: Could not get node token from controller!"
  exit 1
fi

K3S_TOKEN=$(cat /tmp/node-token)

# Install k3s as agent (worker node)
curl -sfL https://get.k3s.io | K3S_URL=https://$CONTROLLER_IP:6443 K3S_TOKEN=$K3S_TOKEN sh -s - --node-ip $WORKER_IP --flannel-iface eth1

echo "K3s worker node setup complete."