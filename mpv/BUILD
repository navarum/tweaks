#!/bin/bash
# NE 23 Apr 2020
# To build mpv
# https://mpv.io/

# Build deps I had to install: waf, ffnvcodec-headers, vulkan-headers
# (use distro tool to get full list)

# location of this script
scriptdir="$(cd $(dirname $0) && pwd)"
set -e

upstream="https://github.com/mpv-player/mpv"

# version 0.31.0
patchbase=13b8363c47291d30418acb7e969237f031d457bf
srcdir=mpv.git
srcpath=$srcdir

pre_configure_hook () {
    # downloads waf
    ./bootstrap.py
}

do_configure () {
  run_verb ./waf configure --prefix $PREFIX \
    --enable-dvdnav
}

do_build () {
    (cd $srcdir && ./waf build -j4)
}

do_install () {
    (cd $srcdir && ./waf install)
}

. $scriptdir/../lib/build-common.sh

eval "$@"

