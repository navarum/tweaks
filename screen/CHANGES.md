## Changes to *[Screen](https://www.gnu.org/software/screen/)*

This version is based on Screen 4.0.2, from 2003. It is mostly for personal use, as some features still lack documentation, the command names could be chosen better, etc. If I know that someone else is using it, then I would be more motivated to clean it up a bit. Please feel free to ask me to do something on the [TODO list](TODO).

The [list of patches](patches/).

----------------

* Add an option `nav_mode` to order the windows as a linked list, rather than as a numbered array. This is more like tabbing window managers. It is like the `renumber-windows` option in Tmux, except that the numbers stay the same.

* Ability to move windows by marking and inserting.

* Support for nested screens. The prefix key is escaped between `C-a (` and `C-a )`.

* Set more than one environment variable from the command-line.

    This patch was almost trivial. I have a script to copy an environment from my shell into screen, and this makes it possible to write a much faster version, now it is 0.02s, vs 0.9s before.

### "Backported" bugfixes:

* Feb 2018 "Avoid mis-identifying systems as SVR4" ec90292592dd2c9d5c108390841e3df24e377ed5

    Fixes recent problem triggered by Systemd, causing Screen to start very slowly as it closes 500,000 nonexistent file descriptors.

* Aug 2008 "Use fuzzy-matching for session names only if required" 5e4c7c57bf7e8eb729e9804ab7643d1dbbddd9bb

    Fixes problem where you cannot attach to a session if its name is similar to another session's name.

### What it lacks:

* Vertical split, layouts, window groups, "sort windows by title"

    I don't really use these, and they make the code more complex. I don't even understand how other people use them.

* 98b6b4105b60150c5bf9d022b2e7de698a62a797, the bug fix for <https://savannah.gnu.org/bugs/?24924>

    This commit causes command-line arguments to Screen commands to be parsed by the same parser that processes .screenrc. So, you can do `screen -S foo -X escape "^aa"` instead of `screen -S foo -X escape $'\001'a`. The problem is that, with this change, you have to escape an undocumented collection of special meta-characters every time you pass a string on the command-line. For example "^" must be escaped as "\\^", "$" as "\\$". But it is more complicated than running your string through Perl's "quotemeta()"; for example the backslash in "\\:" is not removed by the parser. See <https://savannah.gnu.org/bugs/?47247>.

    I think it would have been simpler for the original bug reporter to just use "eval",

        screen -S foo -X eval "escape ^aa"

    ... rather than asking everyone else to write their own code to escape the inputs of `stuff`, `setenv`, `chdir`, `exec`, and so on.

