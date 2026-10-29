#!/usr/bin/env bash
# QEMU test VMs for the auto-install ISOs and the chezmoi migration.
#
#   vm.sh install <arch|fedora> <ISO> [--interactive]
#       blank 40G NVMe disk, unattended install (settings via fw_cfg), serial
#       log in tests/vm/tmp/<distro>-install.log; the VM powers off at the end.
#       --interactive: GUI window and no preset settings, to try the prompts.
#       VM_LUKS=false vm.sh install ...: install without disk encryption.
#   vm.sh run <arch|fedora> [--gl] [--serial] [--yubikey]
#       boot the installed disk in a GUI window.
#       --gl: 3D acceleration through the host GPU (virgl), needed by sway.
#       --serial: no window, serial console in this terminal (Ctrl+A X quits).
#       --yubikey: pass the host YubiKey through (it disappears from the host
#       while the VM runs). Inside the VM: sudo enroll-yubikey, then reboot
#       and unlock with the PIN (Arch only).
#   vm.sh stop <arch|fedora> [--force]    clean power off (--force: kill it)
#   vm.sh status <arch|fedora>            running or stopped
#   vm.sh snapshot <arch|fedora> <name>   save the disk state (VM off)
#   vm.sh revert <arch|fedora> <name>     go back to it (VM off)
#   vm.sh snapshots <arch|fedora>         list them
#   vm.sh exec <arch|fedora> <command>    run a shell command in the running
#       VM as root through the guest agent; prints its output, exits with its
#       exit code
#
# Test credentials: user dario / password "test", LUKS passphrase "test".

set -euo pipefail

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TMP_DIR="${CURRENT_DIR}/tmp"
OVMF_CODE=/usr/share/edk2/x64/OVMF_CODE.4m.fd
OVMF_VARS=/usr/share/edk2/x64/OVMF_VARS.4m.fd

TEST_PASSWORD="test"
TEST_LUKS_PASSPHRASE="test"

usage() { sed -n '2,26p' "$0"; exit 1; }

# qmp <distro> <command>: one QMP command on the VM control socket
qmp() { python3 "${CURRENT_DIR}/qmp.py" "${TMP_DIR}/$1.qmp" "$2"; }

is_running() { qmp "$1" query-status 2> /dev/null; }

# Asks the guest agent (qemu-guest-agent in the VM) to power off. A GNOME or
# sway session ignores the ACPI power button, the agent doesn't
guest_shutdown() { python3 "${CURRENT_DIR}/qga.py" "${TMP_DIR}/$1.qga" shutdown; }

# guest_exec <distro> <command>: runs it with /bin/sh -c in the guest, as root
guest_exec() { python3 "${CURRENT_DIR}/qga.py" "${TMP_DIR}/$1.qga" exec "$2"; }

cmd_stop() {
  local distro="$1" mode="${2:-}" _
  is_running "${distro}" || { echo "${distro} is not running"; return 0; }
  if [[ "${mode}" == --force ]]; then
    qmp "${distro}" quit || true
  else
    if ! guest_shutdown "${distro}" 2> /dev/null; then
      echo "no guest agent answer, pressing the ACPI power button"
      qmp "${distro}" system_powerdown
    fi
    for _ in $(seq 60); do
      is_running "${distro}" || break
      sleep 2
    done
  fi
  if is_running "${distro}"; then
    echo "${distro} still running: try vm.sh stop ${distro} --force"
    exit 1
  fi
  echo "${distro} stopped"
}

# Adds the host YubiKey (Yubico vendor 1050) to ARGS
yubikey_args() {
  local bus dev node
  read -r bus dev < <(lsusb -d 1050: | awk '{ print $2, substr($4, 1, 3); exit }') || true
  [[ -n "${bus:-}" ]] || { echo "no YubiKey plugged in (lsusb -d 1050:)"; exit 1; }
  node="/dev/bus/usb/${bus}/${dev}"
  if [[ ! -w "${node}" ]]; then
    cat << EOF
${node} is not writable by $(id -un): QEMU can't take the YubiKey over. Once:
  echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="1050", TAG+="uaccess"' \\
    | sudo tee /etc/udev/rules.d/70-yubikey-qemu.rules
  sudo udevadm control --reload && sudo udevadm trigger
then unplug and replug the key.
EOF
    exit 1
  fi
  ARGS+=(-device "usb-host,hostbus=$((10#${bus})),hostaddr=$((10#${dev}))")
}

# Fills the global ARGS array
# shellcheck disable=SC2054 # commas belong to qemu options
common_args() {
  local distro="$1" vga="${2:-virtio-vga}"
  ARGS=(-enable-kvm -cpu host -m 6144 -smp 4 \
    -machine q35 \
    -drive "if=pflash,format=raw,readonly=on,file=${OVMF_CODE}" \
    -drive "if=pflash,format=raw,file=${TMP_DIR}/${distro}-vars.fd" \
    -drive "file=${TMP_DIR}/${distro}.qcow2,if=none,id=nvme0" \
    -device nvme,drive=nvme0,serial=deadbeef \
    -nic user,model=virtio-net-pci \
    -device "${vga}" \
    -device qemu-xhci -device usb-tablet \
    -qmp "unix:${TMP_DIR}/${distro}.qmp,server,wait=off" \
    -chardev "socket,path=${TMP_DIR}/${distro}.qga,server=on,wait=off,id=qga0" \
    -device virtio-serial \
    -device virtserialport,chardev=qga0,name=org.qemu.guest_agent.0)
}

write_fw_cfg() {
  local distro="$1"
  local file="${TMP_DIR}/${distro}-autoinstall.env"
  # Plain-text secrets: test VMs only
  cat > "${file}" << EOF
DISK=auto
HOSTNAME=${distro}-vm
USERNAME=dario
FULLNAME=Test User
PASSWORD_HASH=$(openssl passwd -6 "${TEST_PASSWORD}")
LUKS=${VM_LUKS:-true}
LUKS_PASSPHRASE=${TEST_LUKS_PASSPHRASE}
SWAP_SIZE=1g
POWEROFF=true
EOF
  echo "${file}"
}

cmd_install() {
  local distro="$1" iso="$2" mode="${3:-}"
  [[ -f "${iso}" ]] || { echo "ISO not found: ${iso}"; exit 1; }
  mkdir -p "${TMP_DIR}"

  rm -f "${TMP_DIR}/${distro}.qcow2" "${TMP_DIR}/${distro}-install.log"
  qemu-img create -f qcow2 "${TMP_DIR}/${distro}.qcow2" 40G
  cp "${OVMF_VARS}" "${TMP_DIR}/${distro}-vars.fd"

  common_args "${distro}"
  local args=("${ARGS[@]}")
  args+=(-cdrom "${iso}" -boot order=d)

  if [[ "${mode}" == --interactive ]]; then
    qemu-system-x86_64 "${args[@]}"
  else
    args+=(
      -fw_cfg "name=opt/autoinstall,file=$(write_fw_cfg "${distro}")"
      -display none
      -serial "file:${TMP_DIR}/${distro}-install.log"
    )
    echo "Installing (log: ${TMP_DIR}/${distro}-install.log)..."
    qemu-system-x86_64 "${args[@]}"
    if grep -q 'AUTOINSTALL DONE' "${TMP_DIR}/${distro}-install.log"; then
      echo "OK: ${distro} installed"
    else
      echo "FAILED: see ${TMP_DIR}/${distro}-install.log"
      tail -30 "${TMP_DIR}/${distro}-install.log"
      exit 1
    fi
  fi
}

cmd_run() {
  local distro="$1" opt gl=false
  shift
  [[ -f "${TMP_DIR}/${distro}.qcow2" ]] || { echo "not installed: run 'vm.sh install' first"; exit 1; }
  if is_running "${distro}"; then
    echo "${distro} is already running"
    exit 1
  fi
  for opt in "$@"; do
    [[ "${opt}" == --gl ]] && gl=true
  done
  if ${gl}; then
    common_args "${distro}" virtio-vga-gl
    # grab-on-hover: the keyboard goes to the VM while the pointer is on the
    # window, so the host desktop doesn't take Super combos (GNOME keeps
    # Super+Space for the input source)
    ARGS+=(-display "gtk,gl=on,window-close=off,grab-on-hover=on")
  else
    common_args "${distro}"
  fi
  for opt in "$@"; do
    case "${opt}" in
      --gl) ;;
      --serial) ARGS+=(-display none -serial mon:stdio) ;;
      --yubikey) yubikey_args ;;
      *) usage ;;
    esac
  done
  qemu-system-x86_64 "${ARGS[@]}"
}

[[ $# -ge 2 ]] || usage
command="$1" distro="$2"
[[ "${distro}" =~ ^(arch|fedora)$ ]] || usage
shift 2

case "${command}" in
  install) [[ $# -ge 1 ]] || usage; cmd_install "${distro}" "$@" ;;
  run) cmd_run "${distro}" "$@" ;;
  stop) cmd_stop "${distro}" "$@" ;;
  status) if is_running "${distro}"; then echo "${distro} running"; else echo "${distro} stopped"; fi ;;
  snapshot) [[ $# -eq 1 ]] || usage; qemu-img snapshot -c "$1" "${TMP_DIR}/${distro}.qcow2" ;;
  revert) [[ $# -eq 1 ]] || usage; qemu-img snapshot -a "$1" "${TMP_DIR}/${distro}.qcow2" ;;
  snapshots) qemu-img snapshot -l "${TMP_DIR}/${distro}.qcow2" ;;
  exec) [[ $# -ge 1 ]] || usage; guest_exec "${distro}" "$*" ;;
  *) usage ;;
esac
