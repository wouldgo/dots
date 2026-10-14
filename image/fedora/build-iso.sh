#!/usr/bin/env bash
# Runs inside the container: Fedora Everything netinst + kickstart -> ISO in /build/output
set -euo pipefail

FEDORA_VERSION="${FEDORA_VERSION:-44}"
BASE_URL="https://download.fedoraproject.org/pub/fedora/linux/releases/${FEDORA_VERSION}/Everything/x86_64/iso"
CACHE=/build/iso-cache

echo "==> Step 1: find the netinst ISO"
ISO_NAME="$(curl -fsSL "${BASE_URL}/" | grep -o "Fedora-Everything-netinst-x86_64-${FEDORA_VERSION}-[0-9.]*\.iso" | sort -uV | tail -1)"
[[ -n "${ISO_NAME}" ]] || { echo "netinst ISO not found in ${BASE_URL}"; exit 1; }
CHECKSUM_NAME="$(curl -fsSL "${BASE_URL}/" | grep -o "Fedora-Everything-${FEDORA_VERSION}-[0-9.]*-x86_64-CHECKSUM" | sort -uV | tail -1)"

echo "==> Step 2: download ${ISO_NAME} (cached)"
mkdir -p "${CACHE}" /build/output
if [[ ! -f "${CACHE}/${ISO_NAME}" ]]; then
  curl -fL --retry 3 -o "${CACHE}/${ISO_NAME}.part" "${BASE_URL}/${ISO_NAME}"
  mv "${CACHE}/${ISO_NAME}.part" "${CACHE}/${ISO_NAME}"
fi
if [[ -n "${CHECKSUM_NAME}" ]]; then
  curl -fsSL "${BASE_URL}/${CHECKSUM_NAME}" | grep "(${ISO_NAME})" | sed 's/^SHA256 (\(.*\)) = \(.*\)$/\2  \1/' \
    | (cd "${CACHE}" && sha256sum -c -)
fi

echo "==> Step 3: ksvalidator"
ksvalidator -v "F${FEDORA_VERSION}" /build/autoinstall.ks

echo "==> Step 4: mkksiso"
OUTPUT="/build/output/fedora-auto-${FEDORA_VERSION}-$(date +%Y.%m.%d)-x86_64.iso"
rm -f "${OUTPUT}"
# inst.ks= is added by --ks; drop the media check and boot the plain install entry.
# --skip-mkefiboot: rebuilding efiboot.img needs loop devices (not in rootless
# podman); UEFI grub reads the patched grub.cfg from the ISO filesystem anyway
mkksiso --ks /build/autoinstall.ks -r "rd.live.check" -V "Fedora-auto-${FEDORA_VERSION}" \
  --skip-mkefiboot \
  -R 'set default="1"' 'set default="0"' \
  -R 'set timeout=60' 'set timeout=5' \
  "${CACHE}/${ISO_NAME}" "${OUTPUT}"

echo ""
echo "==> Done! ISO ready at: ${OUTPUT}"
