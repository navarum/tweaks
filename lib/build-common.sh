# XXX check screen/BUILD for usage. the variables which are configured
# in that file should be given defaults in this one, and
# screen-specific elements of this file should be removed to that one

: ${PREFIX:=$HOME/navarum-testing}
mybranch=navarum # should avoid conflicts
gitusername='Navarum Eliskar'
gituseremail='48705414+navarum@users.noreply.github.com'
: ${XTERM:=xterm}
browser () {
    # your terminal here
    $XTERM -e zsh >/dev/null 2>&1
}
warn () {
    echo tweaks: "$@" >&2
}
debug () {
    if [[ "$DEBUG" -ne 0 ]]; then
        echo tweaks: "$@" >&2
    fi
}
die() {
    local frame=1
    while caller $frame; do
        ((frame++));
    done
    echo "$*"
    exit 1
}
check_pwd () {
    if [[ "$PWD" != "$scriptdir" ]]; then
        die Wrong pwd: $PWD
        exit 1
    fi
}

cd $scriptdir

fn_exists()
{
    LC_ALL=C type -t $1 | grep -q 'function'
#    LC_ALL=C type $1 | grep -q 'shell function'
}

# optional second argument is a name of a fallback function
run_if_exists() {
    FN="$1"; shift
    if fn_exists "$FN"; then
        "$FN" "$@";
    else
        FN1="$1"
        if test $FN1; then
            debug no hook $FN, defaulting to $FN1
            "$FN1" "$@";
        else
            debug no hook $FN
        fi
        return 0
    fi
}

clone () {
    check_pwd
    if [ ! -f .cloned ]; then
        git clone $upstream $srcdir
        # XXX does this make sense for others?
        (cd $srcdir &&
            git config user.name $gitusername &&
            git config user.email $gituseremail
        )
        run_if_exists post_clone_hook
        touch .cloned
        rm .applied .configured || true
    else
        if [ ! -d $srcdir ]; then
            warn "Looks like $srcdir is missing, remove .cloned to redownload"
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
            warn $f is not older than $than
            return 1;
        fi
    done
    return 0
}
# mod-times of tree
# git ls-tree -r --name-only HEAD | while read f; do date -r $f +%s; done

apply () {
    check_pwd
    [[ "$NODEP" -ne 0 ]] || clone
    if [ -f .applied ]; then
        printf "%s\0" patches/*.patches | (_all_older .applied)
        if printf "%s\0" patches/* | _all_older .applied; then
            warn "Already applied patches; delete .applied to regenerate"
            return 0
        else
            warn "Patches modified since last application, reapplying"
        fi
    else
        warn "Applying"
    fi
    cd $srcdir
    #    if [ "$(git diff-index HEAD | grep -v configure)" ]; then
    if ! git diff-index --quiet HEAD --; then
        warn Working tree dirty, bailing
        exit 1
    fi
    # clean up safely from a previous 'apply'
    if _ref -q $mybranch && _ref -q $mybranch-new; then
        if [[ "$(_ref $mybranch-new)" != "$(_ref $mybranch)" ]]; then
            warn "Error: Branch $mybranch-new doesn't match $mybranch"
            warn "Do you have unexported changes? See BUILD-NOTES.md, or:"
            warn "   git format-patch mybase -o ../patches"
            warn "   git branch -f navarum navarum-new"
            exit 1;
        fi
    fi

    warn "Running git checkout -q $patchbase -f"

    # if $patchbase empty we need to checkout master, so that deleting
    # $mybranch succeeds later (fixes reapply issue in tetris)
    git checkout -q ${patchbase:-master} -f
#   git checkout -q $patchbase -f

    run_if_exists pre_tag_hook

    git tag -d mybase 2>/dev/null || true
    git tag mybase

    # these need to come after 'git checkout mybase', because git will
    # complain if the branch is checked out
    git branch -D $mybranch 2>/dev/null || true
    git branch -D $mybranch-new  2>/dev/null || true

    git checkout -b $mybranch
    shopt -s nullglob
    for p in ../patches/*.patch; do
        warn "Applying $(basename $p)"
        if ! git am -3 -q $p; then
            warn "Apply failed, opening browser"
            browser
            if [ -e .git/rebase-apply ]; then
                warn "$srcdir/.git/rebase-apply still exists, exiting"
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
    rm .configured 2>/dev/null || true
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

default_configure () {
    ./configure "--prefix=$PREFIX"
}

# do the configuration. arguments are var=value, e.g. PREFIX=~/.local
configure () {
    check_pwd
    [[ "$NODEP" -ne 0 ]] || apply
    if [ -f .configured ]; then
        warn "Using old configuration; delete .configured to regenerate"
        return 0;
    fi
    cd $srcpath
    run_if_exists pre_configure_hook
    run_if_exists do_configure default_configure
    run_if_exists post_configure_hook
    cd $scriptdir
    touch .configured
}

: ${buildpath:=$srcpath}
default_build () {
    make -C $buildpath -j8
}

build () {
    check_pwd
    [[ "$NODEP" -ne 0 ]] || configure
    # XXX maybe better to use the subproject build system to check if
    # built?
    # if [ -f .built ]; then
    #     warn "Already built, delete .built to regenerate"
    #     return 0;
    # fi
    run_if_exists do_build default_build
    # touch .built
}

default_install () {
    make -C $buildpath install
}

install () {
    if [[ $# -gt 0 ]]; then
        warn "Found arguments to 'install'; did you mean /usr/bin/install?"
        exit 1
    fi
    check_pwd
    [[ "$NODEP" -ne 0 ]] || build
    run_if_exists do_install default_install
}
