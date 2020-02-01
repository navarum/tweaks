#!/bin/bash

# build depends:
# perl-xml-parser libltdl-dev libcap-dev libsndfile1-dev libudev-dev speex autopoint
# ...

scriptdir="$(cd $(dirname $0) && pwd)"
set -e

#https://gitlab.freedesktop.org/gchini/pulseaudio/tree/all_patches
upstream=https://gitlab.freedesktop.org/gchini/pulseaudio/
patchbase=b08561af0b770459f3eb2197479e5afec0244eb4 # Thu Jan 16 19:14:08 2020 +0100
#patchbase=52104615db9e312d768f49713ac2a7029f706678 # Fri Jul 12 09:33:01 2019
#patchbase=44c5ed24c49b4e78abdf5192abed85885eefce68 # 4.0.2
srcdir=pulseaudio.git
srcpath=$srcdir

configpath=src/configure

post_clone_hook () {
    (cd $srcdir &&
         git fetch "https://gitlab.freedesktop.org/gchini/pulseaudio.git" "all_patches" &&
         git checkout -b all_patches FETCH_HEAD
    )
}

# in $srcpath
pre_configure_hook () {
    ./autogen.sh
}

# XXX check this "BTW, you shoud add --enable-smoother-2 to the
# configure options when using the all_patches branch"
# do_configure () {
#     ./configure "--prefix=$PREFIX"
#         --enable-smoother-2
# }

do_install () {
    sudo make -C $srcpath install
}

. $scriptdir/../lib/build-common.sh

eval "$@"
