## Changes to [URxvt (rxvt-unicode)](http://software.schmorp.de/pkg/rxvt-unicode.html)

Currently this configures and installs URxvt version 9.22, from May 2016 (the latest release had problems when "eval:" appears in `~/.Xdefaults` keybindings). It also includes the following changes:

* Restore user's ability to disable blinking cursor via `~/.Xdefaults` (from commit 0fcacfc153674a124d59cc2445a0048d4ccc3501, 2014)

* Same with "secondary screen", which is a feature that allows some applications to clear the screen when they exit. I find this annoying, because often the thing I was looking at is relevant to my next command.

* Remove certain sequences from the `terminfo` file, relating to the above changes.

  Note that the terminfo changes and the configuration / code changes above are both helpful for eliminating problem behavior. For example, if I login to a remote host with the unmodified rxvt-unicode terminfo database, then it is helpful for the terminal emulator which I am running locally to ignore `rmcup` and `cvvis` commands. However, if there is an additional terminal emulator, such as mosh, between me and the app, then it might interpret "\E[r" (CSI_72, part of `rmcup`) coming from the app, and change it to something else. But if I copy my modified terminfo to the remote host, then the app will not even send "\E[r".

* Add my url-mode-select script. To use it, put something like this in `~/.Xdefaults`:

      URxvt.perl-ext-common: ...,url-mode-select,...
      URxvt.keysym.Mod1-u: perl:url-mode-select:activate
      URxvt.url-mode-select.launcher: clipboard-fake-launcher
      URxvt.url-mode-select.underline: false

  It is based on Bert Muennich's "`url-select`". My modification was to add "modes" to it, so for example one could alternate between selecting "URLs", "lines of text", "file names", "stuff entered at command prompts", and so on. It uses an additional configuration file `url-mode-patterns.pl`, which can go in `~/.urxvt/` (if you don't like the default). In the above configuration, `clipboard-fake-launcher` is a custom script which just copies its argument to the clipboard.

      $ cat =clipboard-fake-launcher
      #!/bin/sh
      printf %s "$1" | xclip -i -selection clipboard

  Hence when you "select" a link, instead of "launching" a browser, it just gets copied to the clipboard. Another keybinding (via [xbindkeys](https://wiki.archlinux.org/index.php/Xbindkeys)) launches the browser from the clipboard. The cost is an extra keystroke to open a URL; but the benefit is that I can change the second keystroke from "open a browser" to "open in gedit" or "yank (into Emacs)" or anything else that might conceivably take input from the clipboard - so it is considerably more flexible than setting "launcher" to a browser.
