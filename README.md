# dotfiles

## extensible, configurable bashrc system

main entry point is `.bashrc-new` - source this at the bottom of the default `.bashrc` or `.bash_profile`, to prevent messing with that stuff. `.bashrc-new` contains basic, common setup, environment detection, and branching logic

functionality is split into four main components...
* `.paths-*` - define `$PATH`, `$CDPATH`, other language-specific or app-specific paths
* `.alias-*` - define aliases
* `.prompt-*` - define extra stuff to happen within `$PROMPT_COMMAND` function
* `.bashrc-*` - any shell config that doesn't fit into the above categories.

...and further split into an arbitrary number of environment-specific files, for example:
* `.bashrc-osx` - osx-specific shell config (`$OS`)
* `.paths-umbel-macbook` - work laptop-specific path setup (`$MACHINE`)
* `.alias-raspberry-pi` - raspberry pi-specfic aliases (`$MACHINE`)
* `.prompt-home` - home location-specific `$PROMPT_COMMAND` actions (`$LOCATION`)

these depend on some (bash) environment variables that contain (real-world) environment info:
- `$LOCATION` - physical location, determined from `$WIFI_NETWORK`, which comes from `nm-tool` or `airport -I`
- `$MACHINE` - human-readable name for machine, determined from `$WIFI_MAC`, which comes from `ifconfig $INTERFACE`
- `$OS` - human-readable name for OS, determined from `$KERNEL`, which comes from `uname -s`

`$LOCATION` and `$MACHINE` are defined in some bash scripts that aren't present in this repo

`.bashrc-$MACHINE` usually defines `$PSCOLOR1` and `$PSCOLOR2`, which set machine-specific `$PS1` prompt colors. I use this to visually identify terminals running SSH sessions.

additionally, `$HOME_SERVER` is used to decide whether any remote config should be used:
* `.bashrc-not-bigpanda` - track home server's dynamic IP for easy SSH access



### why?
I have a bunch of common functionality I want on every machine I use, and I also have a little bit of machine/platform-specific functionality, in a mutually exclusive kind of way. I also value the ability to completely set up a new machine as quickly and painlessly as possible. for years, I've dealt with these issues in an ad-hoc way that has left me with a giant pile of .bashrc_* files that are basically impossible to maintain. this structure has worked much better, so far.