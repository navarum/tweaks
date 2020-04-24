## Changes to [w3m](http://w3m.sourceforge.net/)

* Make `-X` the default. Anyway this should have been a configuration option.

* Wrap PRE tags. This makes some websites, such as Bugzilla, usable. And everything else becomes less annoying.

    $ w3m 'https://bugs.r-project.org/bugzilla/show_bug.cgi?id=17671'
    ...
    I just noticed when the fisher.test function is called in a do.call, there would be
    some redundant outputs in the results. See the example below:

    set.seed(123456)
    ...

    $ /usr/bin/w3m 'https://bugs.r-project.org/bugzilla/show_bug.cgi?id=17671'
    ...
    I just noticed when the fisher.test function is called in a do.call, there would be som

    set.seed(123456)
    ...
