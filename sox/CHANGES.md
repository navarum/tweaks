## Changes to *[Sox](https://sourceforge.net/p/sox/code/ci/master/tree/)*

- *Don't print help text on error.* The upstream version of Sox  prints the entire help text whenever command-line parsing results in an error. This is annoying because the help text is several pages long. So whenever you forget the complicated command-line syntax of Sox, instead of a helpful error message, you have to scroll up through several pages of mostly-irrelevant text to see what the problem is. This also obscures your interactive shell history. See [here](example-error.md) for an example of this problem and how it is fixed with my short patch. Sox maintainer Mans Rullgard refuses to apply this patch with a terse "I fail to see the problem.".

