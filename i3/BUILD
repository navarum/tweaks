#!/bin/bash
# NE 17 Nov 2023

scriptdir="$(cd $(dirname $0) && pwd)"
set -e

upstream="https://github.com/i3/i3/"

# NE 17 Nov 2023 Just the release I downloaded, haven't had a reason
# to update
patchbase=70288d7b68ed064e33fa32d96f19b3fa341271be
srcdir=i3-source
srcpath=$srcdir
# true but not used: buildpath=$srcpath/build

# build instructions are in i3-source/PACKAGE-MAINTAINER
do_configure () {
  mkdir -p build &&
    (cd build &&
    meson ..)
}

do_build () {
  cd build && ninja
}

do_install () {
  >&2 echo Installing link in $PREFIX/bin/i3
  # install in ~/.local/bin/ ?
  ln -srf i3-source/build/i3 $PREFIX/bin/
}

. $scriptdir/../lib/build-common.sh

eval "$@"

