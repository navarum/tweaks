Usage:

./BUILD clone
./BUILD apply
PREFIX=~/.local/ ./BUILD configure
./BUILD build
./BUILD install

or just

PREFIX=~/.local/ ./BUILD install

(which will pull in the other dependencies)

----------------

* To edit the patch series:

Do ./BUILD apply and cd to the source directory. The patches fall
between the commit tagged 'mybase', and the branch tip 'navarum-new'.

git commit
git rebase -i mybase

* To export a new patch series:

rm -f ../patches/*.patch
git format-patch mybase -o ../patches

* Try applying series to a different base:

git clean
git checkout OTHER_COMMIT
git am -3 ../patches/*

# OR:

XTERM=urxvt ../BUILD apply

# this will open a terminal when a patch fails, and you can fix it
# using git:

editor failed_file.c
git add -u

# --or--

editor ../patches/failed_patch.patch
git apply ../patches/failed_patch.patch
git add -u

# then

git am --continue
^D # exit terminal

----------------------------------------------------------------

The BUILD code is supposed to simple enough so that you can tell what
it's doing to Git. The basics of the "apply" rule are

cd $srcdir
git tag mybase $patchbase
git checkout -b $mybranch
git am ../patches/*.patch
git checkout -b $mybranch-new

The use of two branches $mybranch and $mybranch-new is so we can keep
track of what was applied automatically, and what was added after that
by the user (which we don't want to detach by accident).
