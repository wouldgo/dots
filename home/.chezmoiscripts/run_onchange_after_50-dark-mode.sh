#!/usr/bin/env bash
set -euo pipefail

# Dark mode for every desktop, not only GNOME Shell: GTK4/libadwaita apps and,
# through xdg-desktop-portal, browsers and Electron apps read color-scheme;
# GTK3 apps read gtk-theme.
command -v gsettings >/dev/null || exit 0

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
