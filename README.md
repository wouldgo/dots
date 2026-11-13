# Dots

My configurations. Clone this repo to `${HOME}/git/dots`.

## Structure

| Directory | Content |
|---|---|
| `image/` | Installer ISOs for Arch and Fedora. See [image/README.md](image/README.md). |
| `tests/vm/` | QEMU test VMs for the ISOs and for chezmoi. |
| `home/` | The chezmoi source. `.chezmoiroot` points to it. |

## 1. Make a new image

You need rootless podman. To set it up, see the
[podman rootless tutorial](https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md).

1. Go to the repo: `cd ~/git/dots`.
2. Build the Arch ISO: `./image/arch/build.sh`.
3. Or build the Fedora ISO: `./image/fedora/build.sh`.
4. Find the ISO in `image/<distro>/out/`.
5. Write the ISO to a USB stick. For the ways to do it, see
   [USB flash installation medium](https://wiki.archlinux.org/title/USB_flash_installation_medium)
   on the Arch wiki.

For the disk layout, the settings and the install steps, see [image/README.md](image/README.md).

## 2. Test the image locally

You need QEMU and the OVMF (edk2) firmware. For more data, see
[QEMU](https://wiki.archlinux.org/title/QEMU) on the Arch wiki and the
[OVMF wiki](https://github.com/tianocore/tianocore.github.io/wiki/OVMF).
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

This is a TL;DR. The full information is in the chezmoi docs:
[quick start](https://www.chezmoi.io/quick-start/),
[init](https://www.chezmoi.io/reference/commands/init/),
[apply](https://www.chezmoi.io/reference/commands/apply/).

1. Install `git` and `chezmoi`.
2. Clone the repo: `git clone https://github.com/wouldgo/dots.git ~/git/dots`.
3. Apply: `chezmoi init --apply --source ~/git/dots`.
4. If chezmoi asks about the Apple keyboard, laptop, gaming, sway, greetd or SSH logins, answer the questions.
   Answer no to sway where you can only use GNOME: chezmoi skips its packages and configs.
   Answer yes to greetd to replace GDM with tuigreet at the next boot. GNOME under greetd is not tested.
   Answer yes to SSH logins on a machine that other machines open apps from (see section 6).
5. Log out and log in again.

To get changes later:

1. Pull: `git -C ~/git/dots pull`.
2. Apply: `chezmoi apply`.

## 4. Add new stuff

All changes go in `home/`. After each change, run `chezmoi diff` to see it. Then run `chezmoi apply`.
For these two commands, see the chezmoi docs:
[diff](https://www.chezmoi.io/reference/commands/diff/),
[apply](https://www.chezmoi.io/reference/commands/apply/).

### Add a package

1. Open `home/.chezmoidata/packages.yaml`.
2. Add the package to a group under `arch` and under `fedora`.
3. For an AUR package, use the `aur` section.
4. For a third-party dnf repo, use the `fedora_repos` section.

For the file format, see
[.chezmoidata](https://www.chezmoi.io/reference/special-files/chezmoidata-format/)
in the chezmoi docs.

### Add a developer tool

1. Add the tool to `home/dot_config/mise/config.toml`.
2. Run `chezmoi apply`. mise installs the tool.

This is a TL;DR. The full information is in the mise docs:
[dev tools](https://mise.jdx.dev/dev-tools/),
[configuration](https://mise.jdx.dev/configuration.html).

### Add an agent skill

The global skills of Claude Code, Codex and Pi are listed in
`home/.chezmoidata/skills.yaml`. `chezmoi apply` installs them with the
`skills` CLI and removes the global skills that are not in the list.

1. Install the skill: `skills add <owner/repo> -g -s <skill>`.
   To remove one: `skills remove -g -s <skill>`.
2. Write the installed skills to the list: `skills-sync save`.
3. Commit `home/.chezmoidata/skills.yaml`. On the other machines, `chezmoi apply`.

You can also edit the list by hand and run `chezmoi apply` (or `skills-sync apply`).
To update the skills to their latest version: `skills update -g -y`.
A skill that you install and do not save goes away on the next apply.
A skill with `allowed-tools` (tools that the agent runs without asking) is
removed, and `skills-sync apply` fails until the list drops it.

This is a TL;DR. The full information is in `skills --help` and on [skills.sh](https://skills.sh).

### Add a config file

1. Copy the file into chezmoi: `chezmoi add ~/.config/<app>/<file>`.
2. Or add it by hand in `home/`. Use the chezmoi names:
   - `dot_` for a leading dot. Example: `dot_zshrc` is `~/.zshrc`.
   - `executable_` for a file that runs. Put scripts in `home/dot_local/bin/`.
   - `.tmpl` at the end for a template.
3. For a file to download, add it to `home/.chezmoiexternal.toml`.

This is a TL;DR. The full information is in the chezmoi docs:
[add](https://www.chezmoi.io/reference/commands/add/),
[source state attributes](https://www.chezmoi.io/reference/source-state-attributes/),
[templating](https://www.chezmoi.io/user-guide/templating/),
[.chezmoiexternal](https://www.chezmoi.io/reference/special-files/chezmoiexternal-format/).

### Add a value for each machine

1. Add a prompt to `home/.chezmoi.toml.tmpl`. Use `promptBoolOnce`.
2. Add the value to the `[data]` section.
3. Use the value in a `.tmpl` file. Example: `{{ if .isLaptop }}`.
4. Run `chezmoi init` to write the new value.

If the installer can find the value, also write it in the installer.
See `image/arch/overlay/` and `image/fedora/autoinstall.ks`.

This is a TL;DR. The full information is in the chezmoi docs:
[promptBoolOnce](https://www.chezmoi.io/reference/templates/init-functions/promptBoolOnce/),
[templating](https://www.chezmoi.io/user-guide/templating/),
[init](https://www.chezmoi.io/reference/commands/init/).

### Add a setup step

1. Add a script to `home/.chezmoiscripts/`.
2. Start the name with a prefix:
   - `run_onchange_` runs the script when its content changes.
   - `run_` runs the script on each apply.
   - `before_` or `after_` sets when the script runs.
3. Add a number to set the order. Example: `run_onchange_after_70-my-step.sh`.

This is a TL;DR. The full information is in
[use scripts to perform actions](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/)
in the chezmoi docs.

### Test the change

The VM clones the repo from GitHub. Push the change first.
The VM uses the branch in `DOTS_REF`. The default is `feature/chezmoi`.

1. Push the change to your branch.
2. Go back to a clean VM: `tests/vm/vm.sh revert arch fresh-install`.
3. Start the VM: `tests/vm/vm.sh run arch`.
4. In the VM, pull: `git -C ~/git/dots pull`.
5. In the VM, apply: `chezmoi init --apply --source ~/git/dots`.
6. Make sure that the change works.

## 5. Use a WireGuard VPN

NetworkManager keeps the tunnels and their keys, outside this repo.
Do not put a `.conf` file in the repo: it contains the private key.
On each machine, import each tunnel one time:

1. Import: `nmcli connection import type wireguard file wg0.conf`.
   The file name, without `.conf`, is the tunnel name. The tunnel starts at once.
2. To start the tunnel only on request: `nmcli connection modify wg0 connection.autoconnect no`.
3. Delete the `.conf` file if you do not need it.

To start or stop a tunnel:

- GNOME: use the VPN toggle in the quick settings. No extension is necessary.
- sway: click the VPN icon on waybar, or select `VPN` in the settings menu (`$mod+Shift+e`).
  The icon is yellow when a tunnel is up. It is hidden when the machine has no tunnels.

This is a TL;DR. The full information is in
[WireGuard](https://wiki.archlinux.org/title/WireGuard#NetworkManager) on the Arch wiki.

## 6. Open apps of another machine

With waypipe, a Wayland app runs on one machine and shows its window on the
sway of another one, over ssh. Example: the laptop shows zed or kicad of
the desktop. waypipe is installed on all the machines.

On the machine with the apps (the server), one time:

1. Answer yes to SSH logins (`sshServer`). To change the answer later, set
   `sshServer = true` in `~/.config/chezmoi/chezmoi.toml` and do `chezmoi apply`.
   chezmoi enables sshd. Only keys can log in, root cannot.

On the machine with the screen (the client), one time:

1. Make a key if you do not have one: `ssh-keygen -t ed25519`.
2. Copy the key to the server. Passwords are off, so do it on the server: add
   the contents of `~/.ssh/id_ed25519.pub` to `~/.ssh/authorized_keys`.
3. Optional: add a `Host` entry in `~/.ssh/config`. The menu shows these hosts.

To open the apps, select `Remote` in the settings menu (`$mod+Shift+e`) and
select or type the host. A terminal of the server opens. The GUI apps that you
start in this terminal open on the client. Without the menu: `waypipe ssh host alacritty`.

Known problems:

- An app that is already open on the server can open its new window there, not
  on the client (Brave, zed). For Brave, use a different profile:
  `brave --user-data-dir=$HOME/.config/brave-remote`.
- Chromium and Electron apps need `--ozone-platform=wayland`. Without it, they look for X11 and show nothing.
- Black or broken windows from a server with an NVIDIA GPU: try `waypipe --no-gpu ssh host alacritty`.

This is a TL;DR. The full information is in `man waypipe`.

## 7. Use nvim

nvim keeps the Vim modes and adds the VSCode keybindings on top: `Ctrl+S`,
`Ctrl+P`, `Ctrl+Shift+F`, `F12`, `Ctrl+.`, `Ctrl+/`, `Ctrl+D` and the others.
All of them are in `~/.config/nvim/lua/config/keymaps.lua`. To find one, press
`Ctrl+K Ctrl+S`. The other commands start with `Space`: wait a moment after it
and a menu shows them. Window commands are on `Space w` because `Ctrl+W` closes
the editor. `Ctrl+A` belongs to tmux: select all with `ggVG`.

The first start installs the plugins, the language servers and the debuggers.
Wait until it ends (`:Mason` shows the progress), then restart nvim.

To debug Go, Rust, JavaScript or TypeScript, use the VSCode keys:

- `F9` toggles a breakpoint, `Shift+F9` sets a breakpoint with a condition.
- `F5` starts the debug or continues. On the first start, select what to run.
  The configurations of `.vscode/launch.json` are in the list too.
- `F10` step over, `F11` step into, `Shift+F11` step out, `Shift+F5` stop.
- `Ctrl+Shift+D` shows or hides the debug views.

C and C++ use clangd. It needs a `compile_commands.json`, in the project or
in `build/`: CMake writes it with `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`, and
`idf.py build` always writes it. An ESP-IDF project (it has `sdkconfig`) uses
the clangd of esp-clang, installed by chezmoi with `idf_tools.py`.

To debug an ESP32 over the USB serial port, without a JTAG probe:

1. `Space d f` builds a debug firmware (GDB stub, `-Og`) and flashes it.
   The build goes to `~/.cache/nvim/esp-idf-debug/`: the project files do not change.
2. `F5`, then `ESP-IDF: debug over the serial port`. Close `idf.py monitor` first.
3. Go back to the normal firmware with `idf.py flash`.

Only 2 breakpoints at a time: the stub uses the hardware breakpoints of the chip.

Known problems:

- `Ctrl+Shift+P`, `Ctrl+.` and the other `Ctrl+Shift` keys work only in Alacritty
  without tmux: tmux and GNOME Console send them as the plain `Ctrl` key.
  There, use `Space p` (command palette), `Space f` (search in files),
  `Space e` (explorer), `Space m` (problems) and `Space .` (quick fix).
- `:Lazy update` changes `~/.config/nvim/lazy-lock.json`. Bring it back to the
  repo with `chezmoi re-add` (see [Bring back changes made by hand](#8-bring-back-changes-made-by-hand)).

## 8. Bring back changes made by hand

Use this when you change a config file on the machine and want the change in
the repo. This is a TL;DR. The full information is in the chezmoi docs:
[status](https://www.chezmoi.io/reference/commands/status/),
[diff](https://www.chezmoi.io/reference/commands/diff/),
[re-add](https://www.chezmoi.io/reference/commands/re-add/),
[merge](https://www.chezmoi.io/reference/commands/merge/),
[unmanaged](https://www.chezmoi.io/reference/commands/unmanaged/).

1. Find the changed files: `chezmoi status`.
   - An `M` in the first column: you changed the file after the last apply.
   - An `M` in the second column: `chezmoi apply` overwrites the file.
   - An `R` in the second column: a script runs on the next apply.
2. See the change: `chezmoi diff ~/.config/<app>/<file>`.
   - `-` lines are the file on the machine. `+` lines are the repo.
   - `chezmoi diff --reverse` shows the other direction.
3. Copy the change into the repo:
   - A normal file: `chezmoi re-add ~/.config/<app>/<file>`.
     Without a file, `chezmoi re-add` copies all the changed files.
   - A `.tmpl` file: `re-add` does not work. Use
     `chezmoi merge ~/.config/<app>/<file>`, or edit the source with
     `chezmoi edit ~/.config/<app>/<file>`.
4. Find files that chezmoi does not manage: `chezmoi unmanaged ~/.config`.
   Add them with `chezmoi add` (see [Add a config file](#add-a-config-file)).
5. Check the result in the repo: `git -C "$(chezmoi source-path)/.." diff`.
   Then commit.
