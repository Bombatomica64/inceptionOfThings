#! /bin/bash

wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

k3d cluster create mycluster --agents 2