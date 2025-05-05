#!/bin/bash -e

on_chroot <<EOF
adduser "$FIRST_USER_NAME" lpadmin
# sudo pip3 install --user mavproxy pyserial pytime

echo "Installing Docker..."

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

# Install Docker packages
# Use --no-install-recommends to potentially reduce image size
apt-get install -y --no-install-recommends docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add user to docker group to run docker without sudo
usermod -aG docker "$FIRST_USER_NAME" || true # Use || true to prevent build failure if user already in group

echo "Docker installation complete."

EOF
