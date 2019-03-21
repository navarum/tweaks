# tweaks

Patch series for software I use a lot. These are customizations that
for some reason didn't make it into the upstream versions of their
associated projects. This repository is mostly for personal use, but
others are welcome to join in.

    git clone https://github.com/navarum/tweaks tweaks.navarum
    cd tweaks.navarum
    make apply
    make PREFIX=$HOME/.local configure
    make -j8
    make install
