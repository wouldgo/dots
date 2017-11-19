#!/usr/bin/env bash

[[ $EUID -eq 0 ]] || {
  echo "you're not root" 2>&1
  exit 0;
} && \

# clone zsh repo and change to it
git clone git://git.code.sf.net/p/zsh/code /tmp/zsh && \
cd /tmp/zsh && \

# get lastest stable version
BRANCH=$(git describe --abbrev=0 --tags) && \
# Get version number, and revision/commit id when this is available
ZSH_VERSION=$(echo $BRANCH | cut -d '-' -f2,3,4) && \
# go to branch
git checkout $BRANCH && \

# make configure
./Util/preconfig && \

# options from Ubuntu zsh package rules file (http://launchpad.net/ubuntu/+source/zsh)
# updated to zsh 5.0.2 on trusty-tahr
./configure --prefix=/usr \
            --mandir=/usr/share/man \
            --bindir=/bin \
            --infodir=/usr/share/info \
            --enable-maildir-support \
            --enable-max-jobtable-size=256 \
            --enable-etcdir=/etc/zsh \
            --enable-function-subdirs \
            --enable-site-fndir=/usr/local/share/zsh/site-functions \
            --enable-fndir=/usr/share/zsh/functions \
            --with-tcsetpgrp \
            --with-term-lib="ncursesw tinfo" \
            --enable-cap \
            --enable-pcre \
            --enable-readnullcmd=pager \
            --enable-custom-patchlevel=Debian \
            --enable-additional-fpath=/usr/share/zsh/vendor-functions,/usr/share/zsh/vendor-completions \
            LDFLAGS="-Wl,--as-needed -g -Wl,-Bsymbolic-functions -Wl,-z,relro" && \

# compile, test and install
make -j5 && \
make check && \
checkinstall -y --pkgname=zsh --pkgversion=$ZSH_VERSION --pkglicense=MIT make install install.info && \

# make zsh the default shell
sh -c "echo /bin/zsh >> /etc/shells" && \

cd - && \
# remove tmp folder
rm -Rfv /tmp/zsh
