#!/bin/bash -e

on_chroot <<EOF
adduser "$FIRST_USER_NAME" lpadmin
# sudo pip3 install --user mavproxy pyserial pytime

echo "Installing Docker, Ansible, and Minicom..."

# Add Docker's official GPG key
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the Docker repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

apt-get install -y --no-install-recommends docker.io docker-compose ansible minicom

# Add user to docker group to run docker without sudo
usermod -aG docker "$FIRST_USER_NAME" || true

echo "Docker, Ansible, and Minicom installation complete."

EOF
