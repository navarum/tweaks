Each project subdirectory has a BUILD script which can be used to
configure and install it. Or use ./examples/install-tweaks to install
all projects.

Usage:

    ./BUILD clone
    ./BUILD apply
    PREFIX=~/.local/ ./BUILD configure
    ./BUILD build
    ./BUILD install

or just

    PREFIX=~/.local/ ./BUILD install

(which will pull in the other dependencies)

To force a build step to be repeated, remove the corresponding
placeholder file in the project directory (`.cloned`, `.applied`,
`.configured`, etc.).

----------------

* To edit the patch series:

  Do `./BUILD apply` and cd to the source directory. The patches fall
  between the commit tagged 'mybase', and the branch tip 'navarum-new'.

      git commit
      git rebase -i mybase

* To export a new patch series:

      rm -f ../patches/*.patch
      git format-patch mybase -o ../patches
      git branch -f navarum navarum-new # update the branch marker

* Try applying series to a different base:

      git clean
      git checkout OTHER_COMMIT
      git am -3 ../patches/*

  OR:

      XTERM=urxvt ../BUILD apply

  (this will open a terminal when a patch fails, and you can fix it using git:)

      editor failed_file.c
      git add -u

  or:

      editor ../patches/failed_patch.patch
      git apply ../patches/failed_patch.patch
      git add -u

  then:

      git am --continue
      ^D # exit terminal

----------------------------------------------------------------

The BUILD code is supposed to simple enough so that you can tell what
it's doing to Git; I thought that depending on a patch series helper
like `quilt` would make things too complicated. The basics of the
"apply" rule are

    cd $srcdir
    git tag mybase $patchbase
    git checkout -b navarum
    git am ../patches/*.patch
    git checkout -b navarum-new

The reason for using two branches `navarum` and `navarum-new` is so we
can keep track of what was applied automatically, and what might have
been added afterwards to the project Git repo by the user (which we
don't want to detach or overwrite by accident). The idea is that you
run the command which was given above, `git branch -f navarum
navarum-new`, *only* when you are sure that `../patches/` contains all
your work on the local git repository. If you commit some new changes
to the project code, then the two branches point at different commits,
and the build scripts will refuse to reapply the patches. After
`./BUILD apply` or `git branch -f`, the output of `git log` will be
something like this - showing the three references `mybase`,
`navarum`, and `navarum-new`:

    commit ea4... (HEAD -> navarum-new, navarum)
    Author: Navarum <...>
        Patch 3 description
    commit bcf...
    Author: Navarum <...>
        Patch 2 description
    commit 29a...
    Author: Navarum <...>
        Patch 1 description
    commit 302... (tag: mybase)
    Author: Upstream Maintainer <...>
        The last commit before our patches ($patchbase)

With this workflow, which I hope is not too confusing, one has the
choice of editing the patches `patches/*.patch` directly, or editing
them in the project checkout using a tool like `git rebase -i` and
then re-exporting to `../patches`.
