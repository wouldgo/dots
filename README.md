# Dots

My configurations. Clone this repo to `${HOME}/git/dots`.

## Structure

| Directory | Content |
|---|---|
| `image/` | Installer ISOs for Arch and Fedora. See [image/README.md](image/README.md). |
| `tests/vm/` | QEMU test VMs for the ISOs and for chezmoi. |
| `home/` | The chezmoi source. `.chezmoiroot` points to it. |

## 1. Make a new image

You need rootless podman.

1. Go to the repo: `cd ~/git/dots`.
2. Build the Arch ISO: `./image/arch/build.sh`.
3. Or build the Fedora ISO: `./image/fedora/build.sh`.
4. Find the ISO in `image/<distro>/out/`.
5. Write the ISO to a USB stick.

For the disk layout, the settings and the install steps, see [image/README.md](image/README.md).

## 2. Test the image locally

You need QEMU and the OVMF (edk2) firmware.
The test user is `dario`. The password and the LUKS passphrase are `test`.

1. Install the ISO in a new VM:
   `tests/vm/vm.sh install arch image/arch/out/arch-auto-*.iso`
2. Wait. The VM powers off at the end.
3. Save the clean disk: `tests/vm/vm.sh snapshot arch fresh-install`.
4. Start the VM: `tests/vm/vm.sh run arch`. For sway, add `--gl`.
5. Log in and test.
6. Stop the VM: `tests/vm/vm.sh stop arch`.
7. Go back to the clean disk: `tests/vm/vm.sh revert arch fresh-install`.

Use `fedora` in place of `arch` for the Fedora VM.
To see all commands, run `tests/vm/vm.sh` with no arguments.
For more data, see "Test in QEMU" in [image/README.md](image/README.md#test-in-qemu).

## 3. Install the customizations with chezmoi

The installer ISO clones the repo and writes the chezmoi data.
On a different machine, do steps 1 and 2 first.

1. Install `git` and `chezmoi`.
2. Clone the repo: `git clone https://github.com/wouldgo/dots.git ~/git/dots`.
3. Apply: `chezmoi init --apply --source ~/git/dots`.
4. If chezmoi asks about the Apple keyboard, laptop or NVIDIA, answer the questions.
5. Log out and log in again.

To get changes later:

1. Pull: `git -C ~/git/dots pull`.
2. Apply: `chezmoi apply`.

## 4. Add new stuff

All changes go in `home/`. After each change, run `chezmoi diff` to see it. Then run `chezmoi apply`.

### Add a package

1. Open `home/.chezmoidata/packages.yaml`.
2. Add the package to a group under `arch` and under `fedora`.
3. For an AUR package, use the `aur` section.
4. For a third-party dnf repo, use the `fedora_repos` section.

### Add a developer tool

1. Add the tool to `home/dot_config/mise/config.toml`.
2. Run `chezmoi apply`. mise installs the tool.

### Add a config file

1. Copy the file into chezmoi: `chezmoi add ~/.config/<app>/<file>`.
2. Or add it by hand in `home/`. Use the chezmoi names:
   - `dot_` for a leading dot. Example: `dot_zshrc` is `~/.zshrc`.
   - `executable_` for a file that runs. Put scripts in `home/dot_local/bin/`.
   - `.tmpl` at the end for a template.
3. For a file to download, add it to `home/.chezmoiexternal.toml`.

### Add a value for each machine

1. Add a prompt to `home/.chezmoi.toml.tmpl`. Use `promptBoolOnce`.
2. Add the value to the `[data]` section.
3. Use the value in a `.tmpl` file. Example: `{{ if .isLaptop }}`.
4. Run `chezmoi init` to write the new value.

If the installer can find the value, also write it in the installer.
See `image/arch/overlay/` and `image/fedora/autoinstall.ks`.

### Add a setup step

1. Add a script to `home/.chezmoiscripts/`.
2. Start the name with a prefix:
   - `run_onchange_` runs the script when its content changes.
   - `run_` runs the script on each apply.
   - `before_` or `after_` sets when the script runs.
3. Add a number to set the order. Example: `run_onchange_after_70-my-step.sh`.

### Test the change

The VM clones the repo from GitHub. Push the change first.
The VM uses the branch in `DOTS_REF`. The default is `feature/chezmoi`.

1. Push the change to your branch.
2. Go back to a clean VM: `tests/vm/vm.sh revert arch fresh-install`.
3. Start the VM: `tests/vm/vm.sh run arch`.
4. In the VM, pull: `git -C ~/git/dots pull`.
5. In the VM, apply: `chezmoi init --apply --source ~/git/dots`.
6. Make sure that the change works.
