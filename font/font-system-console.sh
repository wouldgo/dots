#!/usr/bin/env bash

[[ $EUID -eq 0 ]] || {
  echo "your're not root" 2>&1
  exit 1;
} && \

cp -r "${HOME}"/git/confs/dots/powerline-fonts/Terminus/PSF/*.psf.gz /usr/share/consolefonts && \
sed -i -re"s/(CODESET=.*)/# \1/g" /etc/default/console-setup && \
sed -i -re"s/(FONTFACE=.*)/# \1/g" /etc/default/console-setup && \
sed -i -re"s/(FONTSIZE=.*)/# \1/g" /etc/default/console-setup && \
echo "FONT=\"ter-powerline-v32b.psf.gz\"" >> /etc/default/console-setup && \
sed -i -re"s/#.*GRUB_GFXMODE=.*/GRUB_GFXMODE=1024x768x16/g" /etc/default/grub && \
echo "GRUB_GFX_PAYLOAD_LINUX=keep" >> /etc/default/grub && \
update-grub && \

echo "
 ---------------
| Please reboot |
 ---------------
"
