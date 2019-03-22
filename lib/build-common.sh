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

clone () {
    if [ ! -f .cloned ]; then
        git clone $upstream $srcdir
        # XXX does this make sense for others?
        (cd $srcdir &&
             git config user.name $gitusername &&
             git config user.email $gituseremail
        )
        touch .cloned
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
    git branch -D $mybranch $mybranch-new || true
    
    git tag -d mybase || true
    git tag mybase $patchbase
    # hide "detached head" message
    git checkout mybase 2>/dev/null
    git checkout -b $mybranch mybase
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
}

# do the configuration. arguments are var=value, e.g. PREFIX=~/.local
configure () {
    apply
    if [ -f .configured ]; then
        >&2 echo "Using old configuration; delete .configured to regenerate"
        return 0;
    fi
    cd $srcpath
    rm -f configure
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
