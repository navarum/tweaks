## Changes to [Mpv](https://mpv.io/)

Currently this just builds Mpv 0.31.0 (December 28, 2019), which is the last version I could find that recognizes GNU long options syntax.

More recent versions of Mpv do not allow e.g. `mpv --start 2:01 foo.mp4`, requiring instead `mpv --start=2:01 foo.mp4` or `mpv -start 2:01 foo.mp4` (the second version resulting in a warning as "dangerous").
