#!/bin/bash
scriptdir="$(cd $(dirname $0) && pwd)"
. ../lib/build-common.sh

set -e

upstream=https://git.savannah.gnu.org/git/screen.git
patchbase=44c5ed24c49b4e78abdf5192abed85885eefce68 # 4.0.2
srcdir=screen.git
srcpath=$srcdir/src/

configpath=src/configure

################################################################

eval "$@"
