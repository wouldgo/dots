# Dots

My configurations. Clone this repo to `${HOME}/git/dots`.

## Structure

| Directory | Content |
|---|---|
| `image/` | Installer ISOs for Arch and Fedora. See [image/README.md](image/README.md). |
| `tests/` | QEMU test VMs for the ISOs and for chezmoi. See [tests/README.md](tests/README.md). |
| `home/` | The chezmoi source. `.chezmoiroot` points to it. |

## 1. Make a new image

Needs rootless podman ([tutorial](https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md)).

1. Build: `./image/arch/build.sh` or `./image/fedora/build.sh`.
2. The ISO is in `image/<distro>/out/`.
3. Write it to a USB stick ([USB flash installation medium](https://wiki.archlinux.org/title/USB_flash_installation_medium)).

Disk layout, settings and install steps: [image/README.md](image/README.md).

## 2. Test the image locally

Needs QEMU and OVMF ([QEMU](https://wiki.archlinux.org/title/QEMU), [OVMF](https://github.com/tianocore/tianocore.github.io/wiki/OVMF)).
Test user `dario`, password and LUKS passphrase `test`.

1. Install in a new VM: `tests/vm/vm.sh install arch image/arch/out/arch-auto-*.iso`. The VM powers off at the end.
2. Save the clean disk: `tests/vm/vm.sh snapshot arch fresh-install`.
3. Start: `tests/vm/vm.sh run arch`. For sway, add `--gl`.
4. Stop: `tests/vm/vm.sh stop arch`.
5. Back to the clean disk: `tests/vm/vm.sh revert arch fresh-install`.

`fedora` in place of `arch` for Fedora. All commands: `tests/vm/vm.sh`.
More: [Test in QEMU](image/README.md#test-in-qemu).

## 3. Install the customizations with chezmoi

The installer ISO, given a dots repo, clones it and answers the keyboard, laptop, gaming and sway questions.
On another machine, do steps 1 and 2 first.

1. Install `git` and `chezmoi`.
2. Clone: `git clone https://github.com/wouldgo/dots.git ~/git/dots`.
3. Apply: `chezmoi init --apply --source ~/git/dots`.
4. Answer the questions:
   - sway: no where only GNOME is allowed. No skips its packages and configs.
   - greetd: yes replaces GDM with tuigreet. GNOME under greetd is not tested.
   - SSH logins: yes on a machine that other machines open apps from (section 6).
5. Log out and log in.

Update: `git -C ~/git/dots pull`, then `chezmoi apply`.

Docs: [quick start](https://www.chezmoi.io/quick-start/), [init](https://www.chezmoi.io/reference/commands/init/), [apply](https://www.chezmoi.io/reference/commands/apply/).

## 4. Add new stuff

All changes go in `home/`. Check with `chezmoi diff`, then `chezmoi apply`.

### Add a package

`home/.chezmoidata/packages.yaml`:

- a group under `arch` and under `fedora`
- `aur`: AUR packages
- `fedora_repos`: third-party dnf repos

Docs: [.chezmoidata](https://www.chezmoi.io/reference/special-files/chezmoidata-format/).

### Add a developer tool

1. Add it to `[tools]` in `home/dot_config/mise/config.toml`.
   Not in the mise registry: also its backend in `[tool_alias]`.
2. `chezmoi apply` installs it.

Docs: [dev tools](https://mise.jdx.dev/dev-tools/), [configuration](https://mise.jdx.dev/configuration.html).

### Add an agent skill

`home/.chezmoidata/skills.yaml` lists the global skills of Claude Code, Codex and Pi.
`chezmoi apply` installs them and removes the global skills not in the list.

1. Install: `skills add <owner/repo> -g -s <skill>`. Remove: `skills remove -g -s <skill>`.
2. Save the list: `skills-sync save`.
3. Commit `skills.yaml`. Other machines: `chezmoi apply`.

- Edit the list by hand, then `chezmoi apply` or `skills-sync apply`.
- Update all: `skills update -g -y`.
- A skill not saved goes away on the next apply.
- A skill with `allowed-tools` is removed, and `skills-sync apply` fails until the list drops it.

Docs: `skills --help`, [skills.sh](https://skills.sh).

### Add a config file

- From the machine: `chezmoi add ~/.config/<app>/<file>`.
- By hand in `home/`: `dot_` for a leading dot, `executable_` for a script
  (scripts go in `home/dot_local/bin/`), `.tmpl` for a template.
- A file to download: `home/.chezmoiexternal.toml`.

Docs: [add](https://www.chezmoi.io/reference/commands/add/), [source state attributes](https://www.chezmoi.io/reference/source-state-attributes/), [templating](https://www.chezmoi.io/user-guide/templating/), [.chezmoiexternal](https://www.chezmoi.io/reference/special-files/chezmoiexternal-format/).

### Add a value for each machine

1. A `promptBoolOnce` prompt in `home/.chezmoi.toml.tmpl`, and the value in `[data]`.
2. Use it in a `.tmpl` file: `{{ if .isLaptop }}`.
3. `chezmoi init` writes the new value.

If the installer can find the value, write it there too: `image/arch/overlay/`, `image/fedora/autoinstall.ks`.

Docs: [promptBoolOnce](https://www.chezmoi.io/reference/templates/init-functions/promptBoolOnce/), [templating](https://www.chezmoi.io/user-guide/templating/), [init](https://www.chezmoi.io/reference/commands/init/).

### Add a setup step

A script in `home/.chezmoiscripts/`, named `run_onchange_after_70-my-step.sh`:

- `run_onchange_`: runs when its content changes. `run_`: runs on each apply.
- `before_` / `after_`: before or after the files.
- The number sets the order.

Docs: [use scripts to perform actions](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/).

### Test the change

1. Clean VM: `tests/vm/vm.sh revert arch fresh-install`.
2. Start: `tests/vm/vm.sh run arch`.
3. Copy the working tree into it, no commit or push: `tests/vm/vm.sh sync arch`.
4. In the VM: `chezmoi init --apply --source ~/git/dots`.

## 5. Use a WireGuard VPN

NetworkManager keeps the tunnels and their keys. Never put a `.conf` in the repo: it has the private key.

On each machine, one time per tunnel:

1. Import: `nmcli connection import type wireguard file wg0.conf`. The file name is the tunnel name; it starts at once.
2. Only on request: `nmcli connection modify wg0 connection.autoconnect no`.
3. Delete the `.conf`.

Start or stop:

- GNOME: the VPN toggle in the quick settings.
- sway: the VPN icon on waybar (yellow when up, hidden with no tunnels), or `VPN` in the settings menu (`$mod+Shift+e`).

Docs: [WireGuard](https://wiki.archlinux.org/title/WireGuard#NetworkManager).

## 6. Open apps of another machine

waypipe shows the window of an app that runs on another machine (the server) on this sway, over ssh.

Server, one time: SSH logins yes (`sshServer = true` in `~/.config/chezmoi/chezmoi.toml`, then `chezmoi apply`).
sshd takes keys only, no root.

Client, one time:

1. A key: `ssh-keygen -t ed25519`.
2. On the server, add `~/.ssh/id_ed25519.pub` to `~/.ssh/authorized_keys`.
3. Optional: a `Host` entry in `~/.ssh/config`. The menu lists these hosts.

Open: `Remote` in the settings menu (`$mod+Shift+e`), then the host. A terminal of the server opens; the GUI apps started there open here.
Without the menu: `waypipe ssh host alacritty`.

Known problems:

- An app already open on the server opens its new window there (Brave, zed). Brave: `brave --user-data-dir=$HOME/.config/brave-remote`.
- Chromium and Electron apps need `--ozone-platform=wayland`.
- Black windows from an NVIDIA server: `waypipe --no-gpu ssh host alacritty`.

Docs: `man waypipe`.

## 7. Use nvim

- Vim modes plus the VSCode keys (`Ctrl+S`, `Ctrl+P`, `Ctrl+Shift+F`, `F12`, `Ctrl+.`, `Ctrl+/`, `Ctrl+D`…), in `~/.config/nvim/lua/config/keymaps.lua`.
- `Ctrl+K Ctrl+S`: find a key. `Space`: the other commands. `Space w`: windows.
- `Ctrl+A` is tmux: select all with `ggVG`.
- The first start installs plugins, language servers and debuggers (`:Mason`); restart nvim after it.

Debug Go (tag `test`), Rust, JavaScript and TypeScript:

- `F9` breakpoint, `Shift+F9` conditional breakpoint.
- `F5` start or continue; `.vscode/launch.json` is in the list.
- `F10` step over, `F11` step into, `Shift+F11` step out, `Shift+F5` stop.
- `Ctrl+Shift+D` debug views.

C and C++: clangd, with `compile_commands.json` in the project or in `build/`
(CMake: `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`; `idf.py build` writes it).
ESP-IDF projects (with `sdkconfig`) use the clangd of esp-clang.

ESP32 debug over the USB serial port, no JTAG:

1. `Space d f`: build a debug firmware in `~/.cache/nvim/esp-idf-debug/` and flash it.
2. `F5`, `ESP-IDF: debug over the serial port`. Close `idf.py monitor` first.
3. Back to the normal firmware: `idf.py flash`.

Only 2 breakpoints at a time.

Known problems:

- The `Ctrl+Shift` keys work only in Alacritty without tmux. Elsewhere: `Space p` command palette,
  `Space f` search in files, `Space e` explorer, `Space m` problems, `Space .` quick fix.
- `:Lazy update` changes `~/.config/nvim/lazy-lock.json`: bring it back with `chezmoi re-add` (section 9).

## 8. Use Zed

- Settings and keybindings of VSCode. `Ctrl+B`: the panels on the right.
- Go with the tag `test`: gopls, debug (`F4`), the `go test` tasks next to the tests.
  gopls and delve come from mise.
- Claude Code: `+` in the agent panel. It asks before every edit and command.

## 9. Bring back changes made by hand

1. Changed files: `chezmoi status`.
   - `M` in column 1: changed on the machine after the last apply.
   - `M` in column 2: `chezmoi apply` overwrites it.
   - `R` in column 2: a script runs on the next apply.
2. The change: `chezmoi diff ~/.config/<app>/<file>` (`-` machine, `+` repo; `--reverse` swaps them).
3. Into the repo:
   - a normal file: `chezmoi re-add ~/.config/<app>/<file>` (no file: all of them).
   - a `.tmpl` file: `chezmoi merge ~/.config/<app>/<file>` or `chezmoi edit ~/.config/<app>/<file>`.
4. Files chezmoi does not manage: `chezmoi unmanaged ~/.config`, then `chezmoi add`.
5. Check and commit: `git -C ~/git/dots diff`.

Docs: [status](https://www.chezmoi.io/reference/commands/status/), [diff](https://www.chezmoi.io/reference/commands/diff/), [re-add](https://www.chezmoi.io/reference/commands/re-add/), [merge](https://www.chezmoi.io/reference/commands/merge/), [unmanaged](https://www.chezmoi.io/reference/commands/unmanaged/).
