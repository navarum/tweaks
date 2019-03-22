# XXX check screen/BUILD for usage. the variables which are configured
# in that file should be given defaults in this one, and
# screen-specific elements of this file should be removed to that one

builddir=build
#: ${PREFIX:=$HOME/.local}
: ${PREFIX:=$HOME/screen-testing}
mybranch=navarum # should avoid conflicts
gitusername='Navarum Eliskar'
gituseremail='48705414+navarum@users.noreply.github.com'
: ${XTERM:=xterm}
browser () {
    # your terminal here
    $XTERM -e zsh >/dev/null 2>&1
}

cd $scriptdir

fn_exists()
{
    LC_ALL=C type $1 | grep -q 'shell function'
}

clone () {
    if [ ! -f .cloned ]; then
        git clone $upstream $srcdir
        # XXX does this make sense for others?
        (cd $srcdir &&
             git config user.name $gitusername &&
             git config user.email $gituseremail
        )
        touch .cloned
        rm .applied .configured || true
    else
        if [ ! -d $srcdir ]; then
            >&2 echo "Looks like $srcdir is missing, remove .cloned to redownload"
            exit 1
        fi
    fi
}

_ref () {
    git show-ref --hash "$@"
}

_all_older () {
    than=$1
    while read -rd '' f; do
        if ! test "$f" -ot "$than"; then
            >&2 echo $f is not older than $than
            return 1;
        fi
    done
    return 0
}
# mod-times of tree
# git ls-tree -r --name-only HEAD | while read f; do date -r $f +%s; done

apply () {
    clone
    if [ -f .applied ]; then
        printf "%s\0" patches/*.patches | (_all_older .applied)
        if printf "%s\0" patches/* | _all_older .applied; then
            >&2 echo "Already applied patches; delete .applied to regenerate"
            return 0
        else
            >&2 echo "Patches modified since last application, reapplying"
        fi
    fi
    cd $srcdir
#    if [ "$(git diff-index HEAD | grep -v configure)" ]; then
    if ! git diff-index --quiet HEAD --; then
        >&2 echo Working tree dirty, bailing
        exit 1
    fi
    # clean up safely from a previous 'apply'
    if _ref -q $mybranch && _ref -q $mybranch-new; then
        if [[ "$(_ref $mybranch-new)" != "$(_ref $mybranch)" ]]; then
            >&2 echo "Error: Branch $mybranch-new doesn't match $mybranch"
            >&2 echo "Do you have uncommitted changes?"
            exit 1;
        fi
    fi

    git checkout -q $patchbase -f

    ################
    # XXX move this into a hook in screen/BUILD
    (cd src && git rm --cached configure Makefile doc/screen.info-1 doc/screen.info-2 doc/screen.info doc/screen.info-4 doc/screen.info-5 doc/screen.info-3)
    git commit -m "Remove generated files" -a
    ################

    git tag -d mybase || true
    git tag mybase
    
    # these need to come after 'git checkout mybase', because git will
    # complain if the branch is checked out
    git branch -D $mybranch || true
    git branch -D $mybranch-new || true

    git checkout -b $mybranch
    for p in ../patches/*.patch; do
        >&2 echo "Applying $(basename $p)"
        if ! git am -3 -q $p; then
            >&2 echo "Apply failed, opening browser"
            browser
            if [ -e .git/rebase-apply ]; then
                >&2 echo "$srcdir/.git/rebase-apply still exists, exiting"
                exit 1
            fi
        fi
    done
    # switch to a new branch, in case user decides to commit new
    # changes. then we can check against old branch and refuse to
    # discard them
    git checkout -b $mybranch-new
    cd $scriptdir
    touch .applied
    rm .configured || true
}

abort_apply () {
    cd $srcdir
    git am --abort
    git checkout -f mybase
}

# regenerate_patches () {
#     return
#     # XXX check for uncommitted changes in patches/
#     rm -f patches/*.patch
#     cd $srcdir
#     git format-patch mybase -o ../patches
# }

# do the configuration. arguments are var=value, e.g. PREFIX=~/.local
configure () {
    apply
    if [ -f .configured ]; then
        >&2 echo "Using old configuration; delete .configured to regenerate"
        return 0;
    fi
    cd $srcpath
    autoconf
    ./configure "--prefix=$PREFIX"
    if ! grep "undef BUGGYGETLOGIN" config.h ; then
        >&2 echo "Something went wrong";
        exit 1;
    fi
    cd $scriptdir
    touch .configured
}

build () {
    configure
    make -C $srcpath -j8
}

install () {
    build
    make -C $srcpath install
}
