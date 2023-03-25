#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

wget -O "${CURRENT_DIR}/gnome-terminal.sh" https://raw.githubusercontent.com/nordtheme/gnome-terminal/v0.1.0/src/sh/nord.sh&& \
wget -O "${CURRENT_DIR}/gedit.xml" https://raw.githubusercontent.com/arcticicestudio/nord-gedit/v0.1.0/src/xml/nord.xml && \
wget -O "${CURRENT_DIR}/nord-dircolors" https://raw.githubusercontent.com/nordtheme/dircolors/v0.2.0/src/dir_colors && \

chmod u+x "${CURRENT_DIR}/gnome-terminal.sh" && \

"${CURRENT_DIR}/gnome-terminal.sh" --loglevel 4 && \
sudo ln -s "${CURRENT_DIR}/gedit.xml" /usr/share/gtksourceview-4/styles/nord.xml
