#!/usr/bin/env bash
# Runs inside the container: upstream releng profile + our overlay -> ISO in /build/output
set -euo pipefail

PROFILE=/build/profile
WORK_DIR=/build/work

echo "==> Step 1: copy releng profile ($(pacman -Q archiso))"
rm -rf "${PROFILE}" "${WORK_DIR}"
cp -a /usr/share/archiso/configs/releng "${PROFILE}"

echo "==> Step 2: apply overlay"
# Our boot entries replace the upstream ones (incl. speech/memtest)
rm -f "${PROFILE}"/efiboot/loader/entries/*.conf
cp -a /build/overlay/. "${PROFILE}/"
cat /build/packages.extra >> "${PROFILE}/packages.x86_64"

# profiledef.sh is sourced: later assignments override upstream values.
# UEFI only: the installed system boots with systemd-boot anyway
cat >> "${PROFILE}/profiledef.sh" << 'EOF'

# --- dots overrides ---
iso_name="arch-auto"
iso_application="Arch Linux automated installer"
bootmodes=('uefi.systemd-boot')
file_permissions+=(
  ["/usr/local/bin/autoinstall"]="0:0:755"
  ["/usr/local/bin/enroll-yubikey"]="0:0:755"
)
EOF
sed -i 's/^default .*/default 01-autoinstall.conf/' "${PROFILE}/efiboot/loader/loader.conf"

# Start the installer on tty1, after the upstream automated_script hook
echo '/usr/local/bin/autoinstall --from-login' >> "${PROFILE}/airootfs/root/.zlogin"

# Rootless podman can't mount devtmpfs: a pacstrap copy that bind mounts the
# container's /dev instead (not --rbind: pacstrap's plain umount can't detach it).
# mkarchiso finds it first in PATH
sed 's|chroot_add_mount udev "$1/dev" -t devtmpfs -o mode=0755,nosuid|chroot_add_mount /dev "$1/dev" --bind|' \
  /usr/bin/pacstrap > /usr/local/bin/pacstrap
grep -q 'chroot_add_mount /dev "$1/dev" --bind' /usr/local/bin/pacstrap \
  || { echo "pacstrap patch didn't apply"; exit 1; }
chmod +x /usr/local/bin/pacstrap

echo "==> Step 3: mkarchiso"
mkdir -p /build/output
mkarchiso -v -r -w "${WORK_DIR}" -o /build/output "${PROFILE}"

echo ""
echo "==> Done! ISO ready in /build/output: $(ls /build/output)"
