# Installer images

These ISOs install a full GNOME system with no personal settings.
Then the machine powers off.
After the first login, chezmoi adds the personal apps and configs (`home/`).

| | Arch (`arch/`) | Fedora (`fedora/`) |
|---|---|---|
| Source | archiso `releng` profile and `overlay/` | Everything netinst ISO and `autoinstall.ks` |
| Disk | ESP 1G, LUKS2, btrfs | ESP 1G, `/boot` ext4 1G, LUKS2, btrfs |
| Boot | systemd-boot, `sd-encrypt` initramfs | GRUB |
| Snapshots | snapper and snap-pac | snapper and the dnf5 actions plugin |
| Scrub | `btrfs-scrub@-.timer`, monthly | `btrfs-scrub.timer` from btrfsmaintenance, monthly |
| System packages | `arch/overlay/airootfs/usr/local/share/autoinstall/packages.txt` | `%packages` in `fedora/autoinstall.ks` |

The two installers do the same steps:

- They find the CPU microcode, NVIDIA, laptop and Apple keyboard.
- They write the results to `~/.config/chezmoi/chezmoi.toml`. chezmoi does not ask again.
- They clone this repo to `~/git/dots`. `DOTS_REF` sets the branch. The default is `feature/chezmoi`.
- They add a LUKS recovery key and show it one time. Write it down.
- They disable copy on write (CoW) for `~/vms` and `~/.local/share/containers`.
- They install btrfs-assistant and compsize.
- In a VM, they also install qemu-guest-agent.

## Build

Rootless podman builds the ISOs.

```sh
./image/arch/build.sh     # image/arch/out/arch-auto-<date>-x86_64.iso
./image/fedora/build.sh   # image/fedora/out/fedora-auto-<ver>-<date>-x86_64.iso
```

Write the ISO to a USB stick with `dd`. Or use it in QEMU.

Rootless podman has limits. The scripts go around them:
- Arch: mkarchiso uses a copy of pacstrap. The copy bind mounts `/dev` because devtmpfs is not allowed.
- Fedora: mkksiso runs with `--skip-mkefiboot` because loop devices are not allowed. UEFI boot still works.

## Install

1. Boot the USB stick in UEFI mode.
2. Select the disk. Type its path again to confirm. The installer erases all of the disk.
3. Type the hostname, the user and the password.
4. Select if the disk is encrypted. The default is yes.
   With encryption, you type a passphrase at each boot.
   Without encryption, the machine boots to the login screen.
5. With encryption: type the LUKS passphrase. Write down the recovery key.
6. Wait. The machine powers off at the end.

The installer reads the settings from three places. The last one wins:
1. The defaults: `arch/overlay/airootfs/usr/local/share/autoinstall/defaults.env`, or the top of `%pre` in `fedora/autoinstall.ks`.
2. QEMU: `-fw_cfg name=opt/autoinstall,file=<file with KEY=value lines>`.
3. The kernel command line: `autoinstall.<key>=<value>`. Push `e` in the boot menu to edit it.

Example: `autoinstall.disk=/dev/nvme0n1 autoinstall.dots_ref=master`.

`LUKS=true` or `LUKS=false` gives the answer to the encryption question.
If `DISK` and `PASSWORD_HASH` have values, and `LUKS=false` or `LUKS_PASSPHRASE` has a value, the installer asks nothing.
The Arch ISO also has a "live / rescue" boot entry. This entry does not install.

## After the first login

```sh
chezmoi init --apply --source ~/git/dots
```

After that, `chezmoi apply` is sufficient. The config keeps `sourceDir`.

## YubiKey unlock (Arch only)

The YubiKey 4 has no FIDO2. It unlocks LUKS as a PIV smartcard.
The passphrase and the recovery key continue to work.

### Tools

```sh
sudo pacman -S --needed ccid opensc pcsclite yubikey-manager
sudo systemctl enable --now pcscd.socket
```

Without pcscd, ykman shows "PC/SC not available".

### See the state

These commands do not change the key.

```sh
ykman info        # model, firmware, enabled applications
ykman piv info    # PIN tries, PUK state, certificates in the slots
ykman otp info    # OTP slots
```

### Reset PIV

Do this if you forget the PIN or the PUK, or if the PIN is blocked.
The reset erases all PIV keys and certificates.
OpenPGP, U2F, OTP and OATH do not change.

1. Make sure that no PIV slot has a key that you need. Look at `ykman piv info`.
2. Reset PIV:

   ```sh
   ykman piv reset
   ```

   After the reset: PIN `123456`, PUK `12345678`, the default management key.
3. Set a new PIN. Use 6 to 8 characters.

   ```sh
   ykman piv access change-pin
   ```

4. Set a new PUK. Use 8 characters.

   ```sh
   ykman piv access change-puk
   ```

5. Set a random management key. The key keeps it and the PIN protects it.
   At the "current management key" prompt, push Enter for the default key.

   ```sh
   ykman piv access change-management-key --generate --protect
   ```

6. Write the PIN and the PUK in a safe place.

### PIN blocked

Three wrong PINs block the PIN. The PUK unblocks it and sets a new PIN.

```sh
ykman piv access unblock-pin
```

Three wrong PUKs block the PUK. Then only a reset helps.

### Enroll

```sh
sudo enroll-yubikey --new-key   # new RSA key in PIV slot 9d, then enroll
sudo enroll-yubikey             # use the key that is in slot 9d now
```

The script installs the tools.
It adds `pkcs11-uri=auto` to `/etc/crypttab` and the `sd-encrypt-opensc` hook to the initramfs.
To test the token with no reboot:

```sh
sudo cryptsetup open --test-passphrase --token-only /dev/nvme0n1p2
```

To remove the key from LUKS: `systemd-cryptenroll --wipe-slot=pkcs11 <device>`.

### At boot

1. Insert the key.
2. Type the PIN.
3. Touch the key only when it blinks.

Do not touch the key when it does not blink. OTP slot 1 is programmed.
A touch then types a 44 character OTP and Enter, and this counts as a wrong PIN.
Without the key, the passphrase prompt comes after about 30 seconds.

## Recovery

Keep these items in a safe place, not on the disk:
- the LUKS passphrase
- the LUKS recovery key
- the YubiKey PIN and PUK
- a LUKS header backup (see below)

The LUKS keyslots on Arch:

| Keyslot | Content |
|---|---|
| 0 | passphrase |
| 1 | recovery key |
| 2 | YubiKey (PKCS#11 token), only after `enroll-yubikey` |

To see them: `sudo systemd-cryptenroll <luks-partition>`.
To find the LUKS partition: `lsblk -f`. Look for `crypto_LUKS`.
Arch: `/dev/nvme0n1p2`. Fedora: `/dev/nvme0n1p3`.

### Unlock at boot

- With the YubiKey: insert it, type the PIN, touch it when it blinks.
- Without the YubiKey: wait about 30 seconds, then type the passphrase.
- If you forget the passphrase: type the recovery key at the same prompt.

### Unlock from the live ISO

Do this if the system does not boot.

1. Boot the Arch ISO. Select "live / rescue".
2. Open the disk with the passphrase or the recovery key:

   ```sh
   cryptsetup open /dev/nvme0n1p2 root
   ```

3. Mount the system:

   ```sh
   mount -o subvol=@ /dev/mapper/root /mnt
   mount -o subvol=@home /dev/mapper/root /mnt/home
   mount -o subvol=@var_log /dev/mapper/root /mnt/var/log
   mount /dev/nvme0n1p1 /mnt/boot
   arch-chroot /mnt
   ```

4. Repair the system. Then `exit`, `umount -R /mnt`, `cryptsetup close root`, `reboot`.

Fedora: boot the Fedora ISO. Select "Troubleshooting", then "Rescue a Fedora system".

### Boot without the YubiKey prompt

Do this if the YubiKey prompt blocks the boot.
1. Unlock from the live ISO and chroot. See above.
2. In `/etc/crypttab`, remove `,pkcs11-uri=auto`.
3. `mkinitcpio -P`
4. Reboot. The boot asks for the passphrase.

### Roll back the system from a snapshot

Do this if an update breaks the system.
1. Find the snapshot number from the running system or the chroot: `snapper list`.
2. From the live ISO, open the disk. Then mount the top level of btrfs:

   ```sh
   mount -o subvolid=5 /dev/mapper/root /mnt
   mv /mnt/@ /mnt/@broken
   btrfs subvolume snapshot /mnt/@snapshots/<number>/snapshot /mnt/@
   ```

3. Reboot. If the kernel modules do not load, chroot and run `pacman -S linux`.
4. When all works, delete the old root: `btrfs subvolume delete /mnt/@broken`.

### If you lose something

| You lose | Do this |
|---|---|
| The YubiKey | Unlock with the passphrase. Remove the token: `sudo systemd-cryptenroll --wipe-slot=pkcs11 <luks-partition>`. Remove `,pkcs11-uri=auto` from `/etc/crypttab`. Run `sudo mkinitcpio -P`. Enroll a new key if you have one. |
| The PIN | Unblock it with the PUK: `ykman piv access unblock-pin`. |
| The PIN and the PUK | Reset PIV. The key in slot 9d is erased, so the LUKS token does not work. Unlock with the passphrase. Remove the token. Enroll again. |
| The passphrase | Unlock with the recovery key or the YubiKey. Add a new passphrase: `sudo cryptsetup luksAddKey <luks-partition>`. Give the recovery key when it asks for a passphrase. Then remove the old one: `sudo cryptsetup luksKillSlot <luks-partition> 0`. |
| The recovery key | Make a new one. This also removes the old one: `sudo systemd-cryptenroll --wipe-slot=recovery --recovery-key <luks-partition>`. |
| The passphrase, the recovery key and the YubiKey | The data is lost. Only a backup helps. |
| The LUKS header (damaged disk start) | Restore the header backup. See below. |

### LUKS header backup

The header holds all keyslots. If the header is damaged, no key opens the disk.
Make a backup after each keyslot change:

```sh
sudo cryptsetup luksHeaderBackup <luks-partition> --header-backup-file luks-header.img
```

Keep the file on a USB stick, not on the same disk.
The backup also contains old keyslots. A removed passphrase still opens a disk with this header.
To restore it, from the live ISO:

```sh
cryptsetup luksHeaderRestore /dev/nvme0n1p2 --header-backup-file luks-header.img
```

## btrfs

### Layout (Arch)

| Subvolume | Mount point | Note |
|---|---|---|
| `@` | `/` | snapper config `root` |
| `@home` | `/home` | no snapshots |
| `@snapshots` | `/.snapshots` | snapper writes here |
| `@var_log` | `/var/log` | not in the root snapshots |
| `@var_cache_pacman` | `/var/cache/pacman/pkg` | not in the root snapshots |
| `@swap` | `/swap` | swapfile, no CoW |
| `@vms` | `~/vms` | VM images, no CoW, no snapshots |

Fedora uses `root`, `home` and `var_log`. Its swap is zram.
Mount options: `noatime,compress=zstd:1`.

### See the state

```sh
btrfs-assistant              # GUI: subvolumes, snapshots, scrub, balance
btrfs filesystem usage /     # used and free space
btrfs subvolume list /       # all subvolumes
btrfs device stats /         # error counters
compsize /                   # compression ratio
```

### Snapshots

snap-pac (Arch) and the dnf actions (Fedora) make a pre and a post snapshot for each package transaction.

```sh
snapper list                  # all snapshots
snapper status 1..2           # files changed between snapshot 1 and 2
snapper diff 1..2 /etc/fstab  # changes in one file
snapper undochange 1..2       # undo the changes of the transaction
snapper delete 5              # delete snapshot 5
```

Config: `/etc/snapper/configs/root`.
- `TIMELINE_CREATE="no"`: no hourly snapshots.
- `NUMBER_LIMIT="20"`: keep 20 snapshots.
- `NUMBER_LIMIT_IMPORTANT="10"`: keep 10 important snapshots.
- `ALLOW_GROUPS="wheel"`: wheel users can use snapper.

The kernel is on the ESP. Snapshots do not include it.
After a rollback, the kernel and its modules can be different. Then reinstall the kernel package.

### Corrupted files

btrfs keeps a checksum for each block. A scrub reads all blocks and checks them.

```sh
sudo btrfs scrub start /                       # start a scrub
sudo btrfs scrub status /                      # progress and errors
journalctl -k | grep -i 'checksum error'       # the path of each bad file
systemctl list-timers 'btrfs-scrub*'           # the monthly scrub
```

On one disk, btrfs repairs the metadata because it keeps two copies.
btrfs cannot repair the data. Restore the file from a backup.
A snapshot does not help. It uses the same blocks on the disk.
A program that reads a bad file gets an I/O error.

### Size

Subvolumes have no size. They share all of the space.
To limit a subvolume, use a quota. Quotas make btrfs slower.

```sh
sudo btrfs quota enable /
sudo btrfs qgroup limit 100G /home
sudo btrfs qgroup show /
```

To make the filesystem larger, do these steps in this order:
1. Make the partition larger with `parted` or GNOME Disks.
2. `sudo cryptsetup resize root`
3. `sudo btrfs filesystem resize max /`

All steps work while the system runs.
To make it smaller, do the steps in the opposite order. Give the size to `btrfs filesystem resize` first. Example: `-20G`.

To change the swapfile:

```sh
sudo swapoff /swap/swapfile
sudo rm /swap/swapfile
sudo btrfs filesystem mkswapfile --size 16g /swap/swapfile
sudo swapon /swap/swapfile
```

### Copy on write (CoW)

VM images and databases are slow with CoW. Disable CoW on a directory.

```sh
chattr +C ~/vms      # new files in ~/vms have no CoW
chattr -C ~/vms      # new files have CoW again
lsattr -d ~/vms      # "C" in the output means no CoW
```

The attribute changes only new files. Files that have data do not change.
To change a file, copy it into the directory. Then remove the old file.
Files with no CoW have no checksum and no compression.
The mount option `nodatacow` applies to all of the filesystem. Do not use it for one subvolume.

## Test in QEMU

`tests/vm/vm.sh` makes test VMs. The disk is a blank 40G NVMe disk.
User `dario`, password `test`, LUKS passphrase `test`.

```sh
tests/vm/vm.sh install arch image/arch/out/arch-auto-*.iso   # unattended, no window
tests/vm/vm.sh snapshot arch fresh-install                    # VM must be off
tests/vm/vm.sh run arch                                       # window
tests/vm/vm.sh run arch --gl                                  # window with 3D, for sway
tests/vm/vm.sh run arch --serial                              # serial console in this terminal
tests/vm/vm.sh run arch --yubikey                             # the host YubiKey goes into the VM
tests/vm/vm.sh status arch
tests/vm/vm.sh stop arch                                      # clean power off
tests/vm/vm.sh stop arch --force                              # kill the VM
tests/vm/vm.sh snapshots arch
tests/vm/vm.sh revert arch fresh-install
```

Use `fedora` in place of `arch` for the Fedora VM.

### Test sway

1. `tests/vm/vm.sh run arch --gl`
2. Unlock the disk and log in to GNOME.
3. `chezmoi init --apply --source ~/git/dots`
4. Log out. In GDM, select the sway session with the gear button.

sway needs 3D. Without `--gl`, start it with `WLR_RENDERER=pixman sway`.

### Stop a VM

- `vm.sh stop` asks qemu-guest-agent in the VM to power off.
  If the agent does not answer, it pushes the ACPI power button.
  GNOME and sway ignore the power button when a user is logged in.
- `vm.sh stop --force` kills QEMU. Use it only if the clean stop fails.
- In the VM: `sudo poweroff`.
- Close the QEMU window.
- QEMU monitor: push Ctrl+Alt+2, type `quit`. Ctrl+Alt+1 goes back.
- With `--serial`: push Ctrl+A, then X.

### YubiKey in the VM

`--yubikey` moves the host YubiKey into the VM. The host cannot use it while the VM runs.
QEMU must write to the USB device. If not, `vm.sh` shows the udev rule to add one time.
In the VM: `sudo enroll-yubikey --new-key`. Then reboot and type the PIN.
