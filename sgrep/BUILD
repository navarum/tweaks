#!/bin/bash
# NE 15 May 2020
# sgrep BUILD, copied from tetris BUILD

scriptdir="$(cd $(dirname $0) && pwd)"
set -e

upstream=
patchbase=
srcdir=sgrep.git
srcpath=$srcdir

configpath=

do_configure () {
    >&2 echo "No configuration required"
}

do_build () {
    make -C $srcdir
}

do_install () {
    (
        cd $srcpath
        test -d $PREFIX/
        test -d $PREFIX/bin/
        ln -srf sgrep  $PREFIX/bin/
    )
}

. $scriptdir/../lib/build-common.sh

# override clone: create our own repo
clone () {
    check_pwd
    if [ -f .cloned ]; then
        if [ ! -d $srcdir ]; then
            warn "Looks like $srcdir is missing, remove .cloned to redownload"
            exit 1
        fi
        return 0
    fi
    if [ -e sgrep.git ]; then
        warn "Remove sgrep.git and try again"
        exit 1
    fi

    (
        set -x
        # how to get a subdirectory from github:
        # https://stackoverflow.com/questions/600079/how-do-i-clone-a-subdirectory-only-of-a-git-repository
        if [[ ! -e sgrep-1.0.tgz ]]; then
            svn export https://github.com/navarum/archive/trunk/sgrep-1.0.tgz
        fi
        tar -xvf sgrep-1.0.tgz
        mv sgrep-1.0 sgrep.git
        cd sgrep.git
        git init
        git config user.name "Navarum Eliskar"
        git config user.email "48705414+navarum@users.noreply.github.com"
        git add .
        git com -m original
    )
    touch .cloned
}

eval "$@"
