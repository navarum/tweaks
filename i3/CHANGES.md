## Changes to [i3](https://i3wm.org/)

* Don't notify client windows when they become invisible (`_NET_WM_STATE_HIDDEN`). This is useful if you want Firefox to load certain web pages when you are not looking at them (like Google Voice). It saves time by allowing the user to multitask (and may also be seen as a security improvement, because it gives less information about your activity to the websites you visit).

* See my sample configuration and utility scripts in `examples`. These are just meant to be illustrative, and may refer to scripts which are not included here.

# TODO

* Warn users not to use `i3-config-wizard` to generate a configuration. If you use an alternate keyboard layout such as Dvorak, then `i3-config-wizard` will fill your configuration with misleading bindings (split horizontally should be "h" not "j", restart should be "r" not "o"). It is better to use the default configuration and modify by hand.
