#!/usr/bin/env bash
# Install QEMU/binfmt on amd64 host for arm64 pi-gen cross-builds.
# All output is visible (nothing redirected to /dev/null).
set -eu

echo "=== Loading binfmt_misc kernel module ==="
sudo modprobe binfmt_misc
grep binfmt_misc /proc/mounts

echo
echo "=== Installing QEMU and pi-gen host dependencies ==="
sudo apt-get update
sudo apt-get install -y \
  qemu-user-binfmt \
  qemu-user-static \
  binfmt-support \
  arch-test \
  libglib2.0-0t64 \
  quilt \
  libarchive-tools \
  bmap-tools

echo
echo "=== Enabling binfmt handlers ==="
sudo update-binfmts --enable
update-binfmts --display qemu-aarch64
update-binfmts --display qemu-aarch64-rpi 2>&1 || true

echo
echo "=== Configuring Docker QEMU emulation ==="
docker run --privileged --rm tonistiigi/binfmt --install all

echo
echo "=== Verification ==="
echo -n "Host arch-test: "
arch-test arm64

echo -n "Host qemu-aarch64-static: "
qemu-aarch64-static /usr/lib/arch-test/arm64 2>&1 || qemu-aarch64-static /usr/libexec/arch-test/arm64 2>&1

echo
echo "Registered binfmt handlers:"
ls -la /proc/sys/fs/binfmt_misc/

echo
echo "Done. Rebuild the pi-gen Docker image after Dockerfile changes:"
echo "  ./build-docker.sh"
