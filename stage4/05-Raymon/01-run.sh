#!/bin/bash -e

on_chroot <<EOF
adduser "$FIRST_USER_NAME" lpadmin
# sudo pip3 install --user mavproxy pyserial pytime

apt-get install -y --no-install-recommends docker.io docker-compose-plugin ansible minicom

usermod -aG docker "$FIRST_USER_NAME" || true
systemctl enable docker

EOF
