#!/bin/bash

scriptdir="$(cd $(dirname $0) && pwd)"
set -e

upstream=https://github.com/wch/r-source/
#patchbase=9a003136dfcc2c1fda29abe50565e301a814cf5c # this one disappeared!
patchbase=a0b8a1a2ef04c15a5ca5e91525f7e5fa68540502
# commit a0b8a1a2ef04c15a5ca5e91525f7e5fa68540502
# Author: ripley <ripley@00db46b3-68df-0310-9c12-caf00c1e9a41>
# Date:   Sat Dec 28 07:07:59 2019 +0000
#     git-svn-id: https://svn.r-project.org/R/trunk@77624 00db46b3-68df-0310-9c12-caf00c1e9a41


#patchbase=HEAD # NE 30 Dec 2019 does this not work?
srcdir=r-source
srcpath=$srcdir
buildpath=$srcpath/build/

post_clone_hook () {
    (
        mkdir r-source/build
        cd r-source/build

        wget https://raw.githubusercontent.com/lionel-/contributing/master/inst/GNUmakefile
        wget https://raw.githubusercontent.com/lionel-/contributing/master/inst/make-svn-revision

        chmod +x make-svn-revision
    )
    (
        cd r-source
        tools/rsync-recommended
    )
    printf "%s\n" build/ "src/library/Recommended/*gz" >> r-source/.gitignore
}

do_configure () {
    # Adapted from http://singmann.org/installing-r-devel-on-linux/
    # See also https://bookdown.org/lionel/contributing/building-r.html#autotools
    (
        # Assumes $srcpath is $buildpath/..
        # Note STRIP=true is supposed to preserve debugging symbols after install
        cd build
        CC="ccache gcc" \
          CFLAGS="-ggdb -pipe -std=gnu99 -Wall -pedantic" \
          CXX="ccache g++" \
          CXXFLAGS="-ggdb -pipe -Wall -pedantic" \
          FC="ccache gfortran" \
          F77="ccache gfortran" \
          MAKE="make -j8" \
          STRIP=true \
          ../configure \
          --prefix=$PREFIX \
          --enable-R-shlib \
          --cache-file=config.cache \
          --enable-memory-profiling \
          --with-blas \
          --with-lapack \
          --with-readline
    )
}

do_build () {
    make -C $buildpath -j8
}

. $scriptdir/../lib/build-common.sh

eval "$@"
