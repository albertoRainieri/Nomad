#!/bin/bash

echo "[TASK 1] Update & Install Basic packages"
apt update >/dev/null 2>&1
apt upgrade -y >/dev/null 2>&1
apt install -y wget vim net-tools gcc make tar git unzip sysstat tree >/dev/null 2>&1

echo "[TASK 2] Install Nomad Binary"
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null 2>&1
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null 2>&1
sudo apt update && sudo apt install nomad >/dev/null 2>&1

echo "[TASK 3] Set up Internal DNS"
sudo sh -c "cat >> /etc/hosts" <<-EOF
192.168.217.100 nmaster.example.com nmaster
192.168.217.101 nclient1.example.com nclient1
192.168.217.102 nclient2.example.com nclient2
EOF

#Install Docker
echo "[TASK 4] Add Docker's official GPG key"
sudo apt-get update >/dev/null 2>&1
sudo apt-get install ca-certificates curl gnupg >/dev/null 2>&1
sudo install -m 0755 -d /etc/apt/keyrings >/dev/null 2>&1
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg >/dev/null 2>&1
sudo chmod a+r /etc/apt/keyrings/docker.gpg 

echo "[TASK 5] Add the repository to Apt sources and install Docker:"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update >/dev/null 2>&1
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >/dev/null 2>&1

echo "give permission to USER for docker"
sudo groupadd -f docker
sudo usermod -aG docker $USER
newgrp docker