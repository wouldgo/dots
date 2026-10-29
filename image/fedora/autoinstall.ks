# Fedora Workstation installer: GPT (ESP + /boot + LUKS2 btrfs), GNOME. It
# produces a complete OS without personal customization, clones the dots repo,
# writes the chezmoi data detected from the hardware and powers off.
#
# Same settings as image/arch, last wins: the defaults in %pre, QEMU fw_cfg
# opt/autoinstall (KEY=value), kernel cmdline autoinstall.<key>=<value>.
# Whatever is still empty is asked on tty6 by %pre.

%pre --interpreter=/bin/bash --erroronfail --log=/tmp/autoinstall-pre.log
set -euo pipefail

declare -A CFG=(
  [DISK]=""
  [HOSTNAME]=""
  [USERNAME]=dario
  [FULLNAME]=""
  [TIMEZONE]=Europe/Rome
  [LANG]=en_US.UTF-8
  [LOCALES]=en_US.UTF-8,it_IT.UTF-8
  [KEYMAP]=us
  # true, false, or empty = ask (default answer yes)
  [LUKS]=""
  # Gaming apps by chezmoi (Steam, Sunshine, GE-Proton): true, false, or empty = ask (default answer no)
  [GAMING]=""
  [DOTS_REPO]=https://github.com/wouldgo/dots.git
  [DOTS_PUSH_URL]=git@github.com:wouldgo/dots.git
  [DOTS_REF]=feature/chezmoi
)

is_true() { [[ "${1,,}" =~ ^(1|y|yes|true|on)$ ]]; }
ks_quote() { local s="${1//\\/\\\\}"; printf '"%s"' "${s//\"/\\\"}"; }

FWCFG=/sys/firmware/qemu_fw_cfg/by_name/opt/autoinstall/raw
modprobe qemu_fw_cfg 2>/dev/null || true
if [[ -r "${FWCFG}" ]]; then
  while IFS= read -r line || [[ -n "${line}" ]]; do
    [[ "${line}" =~ ^[[:space:]]*([A-Za-z_][A-Za-z0-9_]*)=(.*)$ ]] || continue
    CFG[${BASH_REMATCH[1]^^}]="${BASH_REMATCH[2]}"
  done < "${FWCFG}"
fi
for param in $(< /proc/cmdline); do
  case "${param}" in
    autoinstall.*=*) param="${param#autoinstall.}"; key="${param%%=*}"; CFG[${key^^}]="${param#*=}" ;;
  esac
done

UNATTENDED=false
if [[ -n "${CFG[DISK]}" && -n "${CFG[PASSWORD_HASH]:-}" ]] \
  && { ! is_true "${CFG[LUKS]:-true}" || [[ -n "${CFG[LUKS_PASSPHRASE]:-}" ]]; }; then
  UNATTENDED=true
fi

# Progress on the serial port in QEMU tests
if [[ -r "${FWCFG}" && -c /dev/ttyS0 ]]; then
  exec > >(tee /dev/ttyS0) 2>&1
fi

if ! ${UNATTENDED}; then
  exec < /dev/tty6 > /dev/tty6 2>&1
  chvt 6
fi

echo "Fedora automated install (unattended: ${UNATTENDED})"

# --- hardware ---
HAS_NVIDIA=false
lspci -d 10de::0300 2>/dev/null | grep -q . && HAS_NVIDIA=true
lspci -d 10de::0302 2>/dev/null | grep -q . && HAS_NVIDIA=true
IS_LAPTOP=false
compgen -G '/sys/class/power_supply/BAT*' > /dev/null && IS_LAPTOP=true
APPLE_KEYBOARD=false
for dev in /sys/bus/usb/devices/*; do
  [[ "$(cat "${dev}/idVendor" 2>/dev/null)" == 05ac ]] \
    && grep -qi keyboard "${dev}/product" 2>/dev/null && APPLE_KEYBOARD=true
done
echo "nvidia: ${HAS_NVIDIA}, laptop: ${IS_LAPTOP}, apple keyboard: ${APPLE_KEYBOARD}"

# --- disk ---
# Never the install medium (fs label Fedora-*)
excluded="$(lsblk -lnpo PKNAME,LABEL | awk '$2 ~ /^Fedora/ { print $1 }' | sort -u)"
mapfile -t disks < <(lsblk -dnpo NAME,TYPE | awk '$2 == "disk" { print $1 }' \
  | grep -Ev '/dev/(zram|loop|sr)' | grep -vxF "${excluded:-/nonexistent}" || true)
(( ${#disks[@]} > 0 )) || { echo "no target disk found"; exit 1; }

if [[ "${CFG[DISK]}" == auto ]]; then
  CFG[DISK]=""
  for pattern in /dev/nvme /dev/vd /dev/sd; do
    for d in "${disks[@]}"; do
      [[ -z "${CFG[DISK]}" && "${d}" == "${pattern}"* ]] && CFG[DISK]="${d}"
    done
  done
  [[ -n "${CFG[DISK]}" ]] || CFG[DISK]="${disks[0]}"
elif [[ -n "${CFG[DISK]}" ]]; then
  printf '%s\n' "${disks[@]}" | grep -qx "${CFG[DISK]}" \
    || { echo "${CFG[DISK]} is not an available disk"; exit 1; }
else
  echo "Available disks (EVERYTHING on the chosen one will be erased):"
  for i in "${!disks[@]}"; do
    printf '  %d) %s\n' "$((i + 1))" "$(lsblk -dno NAME,SIZE,TRAN,MODEL "${disks[$i]}" | tr -s ' ')"
  done
  while true; do
    read -r -p "Disk number: " choice
    [[ "${choice}" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#disks[@]} )) && break
  done
  d="${disks[$((choice - 1))]}"
  lsblk "${d}"
  read -r -p "Type ${d} to confirm the wipe: " confirm
  [[ "${confirm}" == "${d}" ]] || { echo "not confirmed, nothing touched"; exit 1; }
  CFG[DISK]="${d}"
fi

# --- questions ---
ask() {
  local key="$1" question="$2" default="${3:-}" answer
  [[ -n "${CFG[${key}]:-}" ]] && return 0
  ${UNATTENDED} && { CFG[${key}]="${default}"; return 0; }
  read -r -p "${question}${default:+ [${default}]}: " answer
  CFG[${key}]="${answer:-${default}}"
}
ask_secret() {
  local -n out="$1"
  local first second
  while true; do
    read -r -s -p "$2: " first; echo
    read -r -s -p "Repeat: " second; echo
    [[ -n "${first}" && "${first}" == "${second}" ]] && { out="${first}"; return 0; }
    echo "Empty or not matching, try again."
  done
}

ask HOSTNAME "Hostname" "fedora"
ask USERNAME "User name" "dario"
ask FULLNAME "Full name" ""
# Encryption is optional: a passphrase (or YubiKey PIN) at every boot
ask LUKS "Encrypt the disk? A passphrase is asked at every boot (yes/no)" "yes"
if is_true "${CFG[LUKS]}"; then CFG[LUKS]=true; else CFG[LUKS]=false; fi
# Written to chezmoi.toml: chezmoi installs them
ask GAMING "Install the gaming apps: Steam, Sunshine, GE-Proton (yes/no)" "no"
if is_true "${CFG[GAMING]}"; then CFG[GAMING]=true; else CFG[GAMING]=false; fi
USER_PASSWORD=""
[[ -n "${CFG[PASSWORD_HASH]:-}" ]] || ask_secret USER_PASSWORD "Password for ${CFG[USERNAME]}"
LUKS_PASSPHRASE="${CFG[LUKS_PASSPHRASE]:-}"
if is_true "${CFG[LUKS]}" && [[ -z "${LUKS_PASSPHRASE}" ]]; then
  ask_secret LUKS_PASSPHRASE "Disk encryption passphrase"
fi

disk="$(basename "${CFG[DISK]}")"
extra_locales="$(tr ',' '\n' <<< "${CFG[LOCALES]}" | grep -vx "${CFG[LANG]}" | paste -sd, || true)"

# --- generated kickstart (RAM only: it holds the secrets) ---
{
  echo "lang ${CFG[LANG]}${extra_locales:+ --addsupport=${extra_locales}}"
  echo "keyboard --vckeymap=${CFG[KEYMAP]} --xlayouts=${CFG[KEYMAP]}"
  echo "timezone ${CFG[TIMEZONE]} --utc"
  echo "network --bootproto=dhcp --hostname=${CFG[HOSTNAME]} --activate"
  echo "ignoredisk --only-use=${disk}"
  echo "zerombr"
  echo "clearpart --all --initlabel --disklabel=gpt --drives=${disk}"
  echo "bootloader --boot-drive=${disk}"
  echo "part /boot/efi --fstype=efi --size=1024 --ondisk=${disk}"
  echo "part /boot --fstype=ext4 --size=1024 --ondisk=${disk}"
  if is_true "${CFG[LUKS]}"; then
    echo "part btrfs.01 --fstype=btrfs --grow --ondisk=${disk} --encrypted --luks-version=luks2 --passphrase=$(ks_quote "${LUKS_PASSPHRASE}")"
  else
    echo "part btrfs.01 --fstype=btrfs --grow --ondisk=${disk}"
  fi
  echo "btrfs none --label=fedora btrfs.01"
  echo "btrfs / --subvol --name=root LABEL=fedora"
  echo "btrfs /home --subvol --name=home LABEL=fedora"
  echo "btrfs /var/log --subvol --name=var_log LABEL=fedora"
  if [[ -n "${CFG[PASSWORD_HASH]:-}" ]]; then
    echo "user --name=${CFG[USERNAME]} --gecos=$(ks_quote "${CFG[FULLNAME]}") --groups=wheel --iscrypted --password=$(ks_quote "${CFG[PASSWORD_HASH]}")"
  else
    echo "user --name=${CFG[USERNAME]} --gecos=$(ks_quote "${CFG[FULLNAME]}") --groups=wheel --plaintext --password=$(ks_quote "${USER_PASSWORD}")"
  fi
} > /tmp/autoinstall-generated.ks

# For %post: no secrets in this one, it's copied to the target
cat > /tmp/autoinstall-post.env << EOF
USERNAME=${CFG[USERNAME]}
DISK=${CFG[DISK]}
LUKS=${CFG[LUKS]}
HAS_NVIDIA=${HAS_NVIDIA}
IS_LAPTOP=${IS_LAPTOP}
APPLE_KEYBOARD=${APPLE_KEYBOARD}
GAMING=${CFG[GAMING]}
DOTS_REPO=${CFG[DOTS_REPO]}
DOTS_PUSH_URL=${CFG[DOTS_PUSH_URL]}
DOTS_REF=${CFG[DOTS_REF]}
UNATTENDED=${UNATTENDED}
EOF
# Read by the recovery-key step in %post --nochroot, stays in installer RAM
printf '%s' "${LUKS_PASSPHRASE}" > /tmp/autoinstall-luks-passphrase
chmod 600 /tmp/autoinstall-luks-passphrase

echo "Installing to ${CFG[DISK]} as ${CFG[HOSTNAME]}, user ${CFG[USERNAME]}, luks ${CFG[LUKS]}, gaming ${CFG[GAMING]}, dots ${CFG[DOTS_REF]}"
if ! ${UNATTENDED}; then
  chvt 1
fi
%end

text
%include /tmp/autoinstall-generated.ks

url --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch
repo --name=updates --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f$releasever&arch=$basearch
# the NVIDIA driver and multimedia codecs
repo --name=rpmfusion-free --mirrorlist=https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-$releasever&arch=$basearch
repo --name=rpmfusion-free-updates --mirrorlist=https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-$releasever&arch=$basearch
repo --name=rpmfusion-nonfree --mirrorlist=https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-$releasever&arch=$basearch
repo --name=rpmfusion-nonfree-updates --mirrorlist=https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-$releasever&arch=$basearch

rootpw --lock
firstboot --disable
# text installs default to multi-user.target: boot into GDM
xconfig --startxonboot
selinux --enforcing
poweroff

%packages
@^workstation-product-environment
# keeps the RPM Fusion repos configured after the install
rpmfusion-free-release
rpmfusion-nonfree-release
btrfs-progs
# btrfs tools: GUI for subvolumes, snapshots, scrub; compression ratio
btrfs-assistant
compsize
# btrfs-scrub.timer: monthly scrub of /
btrfsmaintenance
snapper
# dnf5 actions: snapper pre/post snapshots around every transaction
libdnf5-plugin-actions
pciutils
unzip
7zip
git
# bootstraps the dotfiles (chezmoi and git are not in packages.yaml)
chezmoi
%end

%post --nochroot --interpreter=/bin/bash --log=/mnt/sysimage/root/autoinstall-post-nochroot.log
set -euo pipefail
cp /tmp/autoinstall-post.env /mnt/sysimage/root/autoinstall.env
%end

%post --interpreter=/bin/bash --log=/root/autoinstall-post.log
set -euo pipefail
# shellcheck disable=SC1091
source /root/autoinstall.env
[[ -c /dev/ttyS0 && "${UNATTENDED}" == true ]] && exec > >(tee /dev/ttyS0) 2>&1
user="${USERNAME}"
home="/home/${user}"

if [[ "${HAS_NVIDIA}" == true ]]; then
  echo "==> NVIDIA driver (RPM Fusion akmod)"
  dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
fi

# In a VM: clean shutdown from the host (tests/vm/vm.sh stop)
if systemd-detect-virt -q --vm; then
  echo "==> qemu-guest-agent"
  dnf install -y qemu-guest-agent
fi

echo "==> snapper"
snapper --no-dbus -c root create-config /
sed -i \
  -e 's/^TIMELINE_CREATE=.*/TIMELINE_CREATE="no"/' \
  -e 's/^NUMBER_LIMIT=.*/NUMBER_LIMIT="20"/' \
  -e 's/^NUMBER_LIMIT_IMPORTANT=.*/NUMBER_LIMIT_IMPORTANT="10"/' \
  -e 's/^ALLOW_GROUPS=.*/ALLOW_GROUPS="wheel"/' \
  /etc/snapper/configs/root
systemctl enable snapper-cleanup.timer btrfs-scrub.timer
mkdir -p /etc/dnf/libdnf5-plugins/actions.d
cat > /etc/dnf/libdnf5-plugins/actions.d/snapper.actions << 'EOF'
# snap-pac equivalent: pre/post snapshots around every dnf transaction
pre_transaction::::/usr/bin/sh -c echo\ "tmp.cmd=$(ps\ -o\ command\ --no-headers\ -p\ '${pid}')"
pre_transaction::::/usr/bin/sh -c echo\ "tmp.snapper_pre_number=$(snapper\ create\ -t\ pre\ -c\ number\ -p\ -d\ '${tmp.cmd}')"
post_transaction::::/usr/bin/sh -c [\ -n\ "${tmp.snapper_pre_number}"\ ]\ &&\ snapper\ create\ -t\ post\ -c\ number\ --pre-number\ "${tmp.snapper_pre_number}"\ -d\ "${tmp.cmd}"\ ;\ echo\ tmp.cmd=\ ;\ echo\ tmp.snapper_pre_number=
EOF

echo "==> NOCOW dirs for VM images and containers"
mkdir -p "${home}/vms" "${home}/.local/share/containers"
chattr +C "${home}/vms" "${home}/.local/share/containers"

echo "==> dots (${DOTS_REF})"
mkdir -p "${home}/git"
if git clone --branch "${DOTS_REF}" "${DOTS_REPO}" "${home}/git/dots"; then
  if [[ -n "${DOTS_PUSH_URL}" ]]; then
    git -C "${home}/git/dots" remote set-url origin "${DOTS_PUSH_URL}"
  fi
else
  echo "clone failed, clone it by hand after the first login"
fi
mkdir -p "${home}/.config/chezmoi"
cat > "${home}/.config/chezmoi/chezmoi.toml" << EOF
sourceDir = "~/git/dots"

[data]
appleKeyboard = ${APPLE_KEYBOARD}
isLaptop = ${IS_LAPTOP}
hasNvidia = ${HAS_NVIDIA}
gaming = ${GAMING}
EOF
chown -R "${user}:${user}" "${home}"
restorecon -R "${home}"
%end

%post --nochroot --interpreter=/bin/bash --log=/mnt/sysimage/root/autoinstall-recovery.log
set -euo pipefail
# shellcheck disable=SC1091
source /tmp/autoinstall-post.env
out=/dev/tty6
[[ "${UNATTENDED}" == true ]] && out=/dev/null
[[ "${UNATTENDED}" == true && -c /dev/ttyS0 ]] && out=/dev/ttyS0

if [[ "${LUKS}" =~ ^(1|y|yes|true|on)$ ]]; then
  # Only on the target disk: another disk can also have LUKS
  dev="$(lsblk -lnpo NAME,FSTYPE "${DISK}" | awk '$2 == "crypto_LUKS" { print $1; exit }')"
  [[ -b "${dev}" ]] || { echo "no LUKS partition on ${DISK}"; exit 1; }
  # The passphrase comes from installer RAM, never written to the target
  key="$(PASSWORD="$(< /tmp/autoinstall-luks-passphrase)" chroot /mnt/sysimage systemd-cryptenroll --recovery-key "${dev}")"
  [[ "${UNATTENDED}" == true ]] || chvt 6
  cat > "${out}" << EOF

############################################################################
  LUKS RECOVERY KEY (unlocks the disk if you lose the passphrase):

    ${key}

  Write it down now: it is not saved anywhere.
############################################################################
EOF
  if [[ "${UNATTENDED}" != true ]]; then
    typed=""
    while [[ "${typed}" != "done" ]]; do read -r -p "Type 'done' once written down: " typed < /dev/tty6 > /dev/tty6; done
    chvt 1
  fi
fi
rm -f /tmp/autoinstall-luks-passphrase
[[ -c /dev/ttyS0 && "${UNATTENDED}" == true ]] && echo "AUTOINSTALL DONE" > /dev/ttyS0
%end
