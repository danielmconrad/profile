# dotfiles: rtx-rc

Our top-level rc, delivered as a [homesick](https://github.com/technicalpickles/homesick) _castle_.

## Prerequisites

You'll need either a `.bash_profile` or `.zshenv` in your `$HOME` folder to allow for proper linking.

    gem install homesick

## Getting Started

    homesick clone -f reviewtrackers/rtx-rc
    homesick link rtx-rc

Once you've installed this homesick library, you can begin removing the following from your shell profile as they're migrated here:
```bash
export DATA_DIR="${RT_DIR}/rtx/data-dir/var/data"

eval "$($HOME/.rt/bin/rt init -)"

export PATH=$PATH:${RT_DIR}/rtx/env/bin
```

## Updating

    homesick pull rtx-rc
