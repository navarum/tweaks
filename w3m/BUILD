#!/bin/bash
# NE 23 Apr 2020
# To build w3m
# http://w3m.sourceforge.net/

# Build deps I had to install: waf, ffnvcodec-headers, vulkan-headers
# (use distro tool to get full list)

# location of this script
scriptdir="$(cd $(dirname $0) && pwd)"
set -e

# there is also acg/w3m but it is 8 years unmodified, and won't build :(
upstream="https://github.com/tats/w3m"

# version 0.31.0
patchbase=3e46046fe364e0d758cf33aa9a036dd2e736ef04
srcdir=w3m.git
srcpath=$srcdir

# just like screen
pre_tag_hook () {
    # in $srcdir
    git rm configure
    git commit -m "Remove generated files" -a
}

pre_configure_hook () {
    autoconf
}

# NE 16 Jul 2024
# want
# ./configure --enable-image=no
# ./configure --enable-image=no --prefix=$HOME/.local/

# do_configure () {
#     ./waf configure --prefix $PREFIX
# }

# do_build () {
#     (cd $srcdir && ./waf)
# }

# do_install () {
#     (cd $srcdir && ./waf install)
# }

. $scriptdir/../lib/build-common.sh

eval "$@"

