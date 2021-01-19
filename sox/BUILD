#!/bin/bash

# build depends:
# ...

# (warning: sox will decide which libraries to link against based on
# which are present on the system; thus you may find yourself with
# missing functionality even when the build succeeds. to fix this we
# should explicitly mention the packages we need during configuration
# time)

scriptdir="$(cd $(dirname $0) && pwd)"
set -e

#git clone https://git.code.sf.net/p/sox/code sox-code
upstream=https://git.code.sf.net/p/sox/code

# Author: Mans Rullgard <mans@mansr.com>
# Date:   Wed Aug 26 15:30:27 2020 +0100
# build: do not link format modules against libsox
patchbase=dd8b63bdc2966c931b73d5f7a17db336cbec6c21

srcdir=sox-code
srcpath=$srcdir

#configpath=src/configure

# post_clone_hook () {
#     (cd $srcdir &&
#          git fetch "https://gitlab.freedesktop.org/gchini/pulseaudio.git" "all_patches" &&
#          git checkout -b all_patches FETCH_HEAD
#     )
# }

# in $srcpath
pre_configure_hook () {
  autoreconf -i
}

do_install () {
    sudo make -C $srcpath install
}

. $scriptdir/../lib/build-common.sh

eval "$@"
