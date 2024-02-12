#!/bin/bash
# User configuration
curl -sq https://github.com/${github_user}.keys | tee -a /home/${system_user}/.ssh/authorized_keys
# Package installation
dnf install --refresh --assumeyes tree yum-utils git unzip nano vim
# Terraform
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo &&
  dnf install --refresh --assumeyes terraform &&
  echo 'alias tf=terraform' | tee -a /etc/profile.d/aliases.sh
# Docker
dnf install --refresh --assumeyes docker &&
  service docker start &&
  usermod -aG docker ${system_user}
# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" &&
  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl &&
  echo 'alias k=/usr/local/bin/kubectl' | tee -a /etc/profile.d/aliases.sh
# kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.21.0/kind-linux-amd64 &&
  install -o root -g root -m 0755 kind /usr/local/bin/kind
# Reboot
shutdown --reboot
