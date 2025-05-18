#!/bin/bash
# NE 11 Oct 2019
# To build rxvt-unicode ("urxvt")
# http://software.schmorp.de/pkg/rxvt-unicode.html

scriptdir="$(cd $(dirname $0) && pwd)"
set -e

upstream="https://github.com/exg/rxvt-unicode"

# NE 08 Oct 2019 The last release, 9.22. HEAD had some problem with
# "eval:" not working in .Xdefaults
patchbase=3023eb8ca1fe4e3c5e2dae62c1473808cb373f61
# could also use CVS:
# cvs -z3 -d :pserver:anonymous@cvs.schmorp.de/schmorpforge co rxvt-unicode
srcdir=rxvt-unicode.git
srcpath=$srcdir

# git clone 
post_clone_hook () {
    (cd $srcdir &&
         cvs -z3 -d :pserver:anonymous@cvs.schmorp.de/schmorpforge co libev &&
         cvs -z3 -d :pserver:anonymous@cvs.schmorp.de/schmorpforge co libptytty
    )
}

pre_configure_hook () {
    ./autogen.sh
}

do_configure () {
    # The CXXFLAGS is for easier debugging. Note that in addition to
    # disabling swapscreen and frills (including blinking cursor)
    # here, we also have patched doc/etc/rxvt-unicode.terminfo to
    # remove certain related sequences from the terminfo file. Thus,
    # if you want them back, edit the terminfo file.
    CXXFLAGS="-g -O" ./configure \
        "--prefix=$PREFIX" \
        --disable-text-blink \
        --enable-unicode3 \
        --disable-frills \
        --disable-swapscreen \
        --disable-fading \
        --enable-xft \
        --disable-rxvt-scroll \
        --disable-next-scroll \
        --disable-xterm-scroll
}

. $scriptdir/../lib/build-common.sh

eval "$@"

