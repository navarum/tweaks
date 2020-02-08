#!/bin/bash

# NE 30 Dec 2019 this is a bit awkward since we need to build and
# install OCaml in order to build Unison. This step is remembered by
# touching ".built-ocaml". Note that $PREFIX needs to be set during
# "build".

scriptdir="$(cd $(dirname $0) && pwd)"
set -e

upstream=https://github.com/bcpierce00/unison.git
#patchbase=80133f36d670ed458a183857d98aa6bb19559b85
patchbase=26a29f79487484b7982c85e0dc879cf7aaaf584f
srcdir=unison.git
srcpath=$srcdir

configpath=

OCAMLDIR=ocaml-4.08.1

post_clone_hook () {
#    wget -c 'https://caml.inria.fr/distrib/ocaml-4.08/'$OCAMLDIR.tar.xz
    # fetch our own backup copy of the OCaml sources, for when
    # caml.inria.fr is broken (10 Dec 2019)
    wget -c 'https://github.com/navarum/archive/blob/master/ocaml-4.08.1.tar.xz?raw=true' -O ocaml-4.08.1.tar.xz
    tar -xf $OCAMLDIR.tar.xz
}

do_configure () {
    # Unison itself doesn't need to be configured. We have a separate
    # ".configured-ocaml" file so that when patches are reapplied to
    # Unison, OCaml doesn't have to be reconfigured/built.
    if [ -f $scriptdir/.configured-ocaml ]; then
        warn "Already configured OCaml, delete .configured-ocaml to regenerate"
    else
        warn "Configuring OCaml"
        (cd ../$OCAMLDIR && ./configure -prefix $PREFIX)
        touch $scriptdir/.configured-ocaml
        rm -f $scriptdir/.built-ocaml
    fi
}

# Note that we usually only need PREFIX for install, here we need it
# for build as well, because OCaml is installed before Unison is built
do_build () {
    if [ -f .built-ocaml ]; then
        warn "Already built OCaml, delete .built-ocaml to regenerate"
    else
        (cd $OCAMLDIR &&
             #make world &&
             #make --debug=v world.opt &&
             make world.opt &&
             make install)
        touch .built-ocaml
    fi
    # use the ocaml binaries we just built
    export PATH=$PREFIX/bin:$PATH
    # build unison
    make -C $srcdir
}

do_install () {
    make -C $srcdir install INSTALLDIR=$PREFIX/bin/
}

. $scriptdir/../lib/build-common.sh

eval "$@"
