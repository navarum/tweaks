Currently this just builds [Unison](https://github.com/bcpierce00/unison.git) version 2.51.2 using OCaml 4.08.1. Both are installed into `$PREFIX`.

In order to use Unison to sync two different hosts, not only must the version of Unison match on both sides, but the version of OCaml must match as well. This means that in the common case of multiple distributions or architectures, Unison must be rebuilt by the user and installed "locally" on each host. However, rarely (in my experience) does the most recent version of Unison build against the most recent version of OCaml. For example, as of this writing, the latest version of OCaml is 4.09, which will not build Unison 2.51.2.

This "tweak" is mostly just to pair two working versions and automate the installation process.
