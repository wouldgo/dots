# tests

## Test VMs (`vm/`)

`vm/vm.sh` runs Arch and Fedora VMs with QEMU/KVM, to try the auto-install
ISOs and the chezmoi migration. Disk, UEFI variables and sockets live in
`vm/tmp/` (not tracked). Run `vm/vm.sh` with no arguments for the full list of
commands.

```sh
tests/vm/vm.sh install arch path/to/arch.iso   # unattended install
tests/vm/vm.sh run arch --gl                   # boot with 3D acceleration (sway)
tests/vm/vm.sh status arch
tests/vm/vm.sh exec arch 'pacman -Q chezmoi'   # command in the VM, as root
tests/vm/vm.sh stop arch
```

Test credentials: user `dario` / password `test`, LUKS passphrase `test`.

### Driving the VM from the host

While the VM runs, QEMU exposes two UNIX sockets in `vm/tmp/`:

| Socket         | Protocol         | Used for                                       | Helper       |
|----------------|------------------|------------------------------------------------|--------------|
| `<distro>.qmp` | QMP              | controlling QEMU: status, ACPI power off, quit | `vm/qmp.py`  |
| `<distro>.qga` | QEMU guest agent | running commands inside the guest              | `vm/qga.py`  |

The guest agent needs `qemu-guest-agent` running in the VM; the installed
images already have it. Commands run as **root** in the guest.

`vm.sh exec <distro> <command>` goes through the guest agent: it runs the
command with `/bin/sh -c`, waits for it to finish, prints its stdout and
stderr, and exits with its exit code. Everything after the distro name is
joined into one shell line, so quote it:

```sh
tests/vm/vm.sh exec arch 'systemctl --failed; journalctl -b -p err --no-pager'
tests/vm/vm.sh exec arch 'su - dario -c "chezmoi status"'   # as user dario
```

The helpers can also be used directly; both protocols are JSON, one message
per line, so no `socat` is needed on the host:

```sh
tests/vm/qga.py tests/vm/tmp/arch.qga ping               # exits 0 if the agent answers
tests/vm/qga.py tests/vm/tmp/arch.qga exec 'uname -r'
tests/vm/qmp.py tests/vm/tmp/arch.qmp system_powerdown   # ACPI power button
```
