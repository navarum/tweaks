#!/bin/bash

scriptdir="$(cd $(dirname $0) && pwd)"
set -e

upstream=https://gitlab.freedesktop.org/gchini/pulseaudio.git/
patchbase=52104615db9e312d768f49713ac2a7029f706678 # Fri Jul 12 09:33:01 2019
#patchbase=44c5ed24c49b4e78abdf5192abed85885eefce68 # 4.0.2
srcdir=pulseaudio.git
srcpath=$srcdir

configpath=src/configure

post_clone_hook () {
    (cd $srcdir &&
         git fetch "https://gitlab.freedesktop.org/gchini/pulseaudio.git" "rewind_fixes" &&
         git checkout -b "gchini/pulseaudio-rewind_fixes" FETCH_HEAD
    )
}

# in $srcpath
pre_configure_hook () {
    ./autogen.sh
}

do_install () {
    sudo make -C $srcpath install
}

. $scriptdir/../lib/build-common.sh

eval "$@"
