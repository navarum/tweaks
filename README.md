# tweaks

Patch series for software I use a lot. These are customizations that
for some reason didn't make it into the upstream versions of their
associated projects. This repository is mostly for personal use, but
feel free to contact me about it.

    git clone https://github.com/navarum/tweaks tweaks.navarum
    cd tweaks.navarum
    PREFIX=$HOME/.local ./screen/BUILD install

(see `examples/install-tweaks`)

Packages:

* [screen](screen/CHANGES.md)
* [pulseaudio](pulseaudio/) - just using development branch gchini/pulseaudio-rewind_fixes
* [urxvt](urxvt/CHANGES.md) - includes patches to improve support for turning off certain features, like blinking cursor or secondary screen
