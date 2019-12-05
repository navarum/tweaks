#!/bin/bash

scriptdir="$(cd $(dirname $0) && pwd)"
set -e

upstream=https://github.com/bcpierce00/unison.git
patchbase=80133f36d670ed458a183857d98aa6bb19559b85
srcdir=unison.git
srcpath=$srcdir

configpath=

OCAMLDIR=ocaml-4.08.1

post_clone_hook () {
    wget 'https://caml.inria.fr/distrib/ocaml-4.08/'$OCAMLDIR.tar.xz
    tar -xf $OCAMLDIR.tar.xz
#    cd $OCAMLDIR
}

do_configure () {
    (cd ../$OCAMLDIR && ./configure -prefix $PREFIX)
}

do_build () {
    (cd $OCAMLDIR &&
         #make world &&
         make --debug=v world.opt &&
         make install)
    # use the ocaml binaries we just built
    export PATH=$PREFIX/bin:$PATH
    # build unison
    make -C $srcdir
}

do_install () {
    make -C $srcdir install INSTALLDIR=$PREFIX/bin
}

. $scriptdir/../lib/build-common.sh

eval "$@"
