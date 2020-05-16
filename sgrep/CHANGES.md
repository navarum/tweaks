Adapted from http://sgrep.sourceforge.net/

This utility searches for a fixed string in a sorted file.

- I have added an option `-l` to output the greatest lower bound in cases where there is no other match.

- I added a test suite, which requires the package "bats-core" to be installed on Arch (but I think it is just called "bats" on Debian).

An alternative I have found to Sgrep is [2search](https://gitlab.com/ole.tange/tangetools/), which is written in Perl. It is slower but more featureful than Sgrep.
