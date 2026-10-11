curl
cmake
make
time


sudo pacman -S podman     # Arch
sudo dnf install podman   # Fedora

#
sudo dnf group install development-tools

#
dnf install cmake freetype-devel fontconfig-devel libxcb-devel libxkbcommon-devel g++

#
zsh


#
in .bashrc put this at the end:
```sh


if [[ "${SHELL}" != "/bin/zsh" ]]; then
    export SHELL="/bin/zsh"
    exec /bin/zsh -l
fi
```
