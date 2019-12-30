# tweaks

Build scripts and patch series for software I use a lot. These are customizations that for some reason didn't yet make it into the upstream versions of their associated projects. This repository is mostly for personal use, but feel free to contact me about it.

    git clone https://github.com/navarum/tweaks tweaks.navarum
    cd tweaks.navarum
    PREFIX=$HOME/.local ./screen/BUILD install

To build and install everything, use [examples/install-tweaks](examples/install-tweaks):

    git clone https://github.com/navarum/tweaks tweaks.navarum
    ./tweaks.navarum/examples/install-tweaks

See [BUILD-NOTES.md](BUILD-NOTES.md) for more information about the build scripts, and how to edit or add to patch series.

Packages:

* [screen](screen/CHANGES.md) - based on a very old version, with a few productivity enhancements
* [pulseaudio](pulseaudio/CHANGES.md) - just using development branch (`gchini/pulseaudio-rewind_fixes`) until the maintainers adopt these changes
* [urxvt](urxvt/CHANGES.md) - includes patches to improve support for turning off certain features, like blinking cursor or secondary screen
* [unison](unison/CHANGES.md) - build Unison together with a version of OCaml that succeeds in building it
* [GNU R](r/CHANGES.md) - recent version with some minor changes
