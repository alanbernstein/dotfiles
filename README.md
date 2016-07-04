# dotfiles

## extensible, configurable bashrc system

### why?
I have a bunch of common functionality I want on every machine I use, and I also have a little bit of machine/platform-specific functionality, in a mutually exclusive kind of way. I also value the ability to completely set up a new machine as quickly and painlessly as possible. for years, I've dealt with these issues in an ad-hoc way that has left me with a giant pile of .bashrc_$HOSTNAME_$DATE files that are basically impossible to maintain. this structure has worked much better, so far.

using dropbox obviates the need for github, except in the case of raspberry pis, which has no official dropbox client. now that i have 1) multiple pis and 2) this repo in a stable state, putting it up is useful.

you might notice that there are quite a few files here. this is a plus for me - a handful of them are for core functionality, and the rest are relatively small, containing only the minimum amount of configuration for the environment they represent.

### how?

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
* `.alias-terminology` - terminal app-specific aliases (`$TERMINAL_APP`)

these depend on some (bash) environment variables that contain (real-world) environment info:
- `$LOCATION` - physical location, determined from `$WIFI_NETWORK`, which comes from `nm-tool` or `airport -I`
- `$MACHINE` - human-readable name for machine, determined from `$WIFI_MAC`, which comes from `ifconfig $INTERFACE`
- `$OS` - human-readable name for OS, determined from `$KERNEL`, which comes from `uname -s`
- `$TERMINAL_APP` - human-readable name for terminal app, determined from a variety of environment variables set by the respective apps.

`$LOCATION` and `$MACHINE` are defined in some bash scripts that aren't present in this repo

all of this stuff has to live in `$HOME/Dropbox/src/dotfiles` to work properly. that path is sort of 'bootstrapped', so ideally it would be configurable, for the sake of other people using this stuff.


### examples of benefits
`.bashrc-$MACHINE` usually defines `$PSCOLOR1` and `$PSCOLOR2`, which set machine-specific `$PS1` prompt colors. I use this to visually identify terminals running SSH sessions.

additionally, `$HOME_SERVER` is used to decide whether any remote config should be used:
* `.bashrc-not-bigpanda` - track home server's dynamic IP for easy SSH access

`.alias-$TERMINAL_APP` sets different aliases that allow me to use app-specific escape sequence extensions, without paying attention to what app I'm using. terminology (linux) and iterm (osx) are both capable of displaying images in the terminal, but they use different mechanisms. it might be preferable for one executable/script to handle all cases, but I don't know an easy way to do that at the moment, so this is a better solution.