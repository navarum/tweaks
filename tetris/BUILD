#!/bin/bash

scriptdir="$(cd $(dirname $0) && pwd)"
set -e

upstream=
patchbase=
srcdir=bsdgames.git
srcpath=$srcdir

configpath=

do_build () {
    make -C $buildpath ./tetris/tetris
}

do_install () {
    (
        cd $buildpath
        test -d $PREFIX/
        test -d $PREFIX/bin/
        /usr/bin/install -c -m 0755 tetris/tetris  $PREFIX/bin/
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

    (
        set -x
        # how to get a subdirectory from github:
        # https://stackoverflow.com/questions/600079/how-do-i-clone-a-subdirectory-only-of-a-git-repository
        svn export https://github.com/navarum/archive/trunk/bsdgames-debian

        cd bsdgames-debian/

        tar -xvf bsdgames_2.17.orig.tar.gz
        mv bsd-games-2.17 ../bsdgames.git
        cd ../bsdgames.git
        git init
        git config user.name "Navarum Eliskar"
        git config user.email "48705414+navarum@users.noreply.github.com"
        git add .
        git com -m original
        gunzip < ../bsdgames-debian/bsdgames_2.17-10.diff.gz| patch -p1
        git com -m debian-patched -a

        # keep patches small
        warn "Removing unneeded games"
        git rm SECURITY YEAR2000 TODO
        for i in */Makefrag; do
            if [[ $i != tetris* ]]; then
                n=${i%/*}; git rm $n -r; rm -rf $n;
            fi;
        done
        git com -m "Removed unneeded files" -a
    )
    touch .cloned
}

eval "$@"
