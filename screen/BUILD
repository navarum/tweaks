#!/bin/bash

scriptdir="$(cd $(dirname $0) && pwd)"
set -e

upstream=https://git.savannah.gnu.org/git/screen.git
patchbase=44c5ed24c49b4e78abdf5192abed85885eefce68 # 4.0.2
srcdir=screen.git
srcpath=$srcdir/src/

configpath=src/configure

pre_tag_hook () {
    # in $srcdir
    (cd src && git rm --cached configure Makefile doc/screen.info-1 doc/screen.info-2 doc/screen.info doc/screen.info-4 doc/screen.info-5 doc/screen.info-3)
    git commit -m "Remove generated files" -a
}

post_configure_hook () {
    if ! grep "undef BUGGYGETLOGIN" config.h ; then
        >&2 echo "BUILD: Something went wrong, configure didn't undef BUGGYGETLOGIN";
        exit 1;
    fi
}

. $scriptdir/../lib/build-common.sh

eval "$@"
