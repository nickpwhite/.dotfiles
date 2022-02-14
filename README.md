# .dotfiles
My dotfiles are managed with [GNU stow](https://www.gnu.org/software/stow/).

## Installation
1. Clone the repository, including submodules 4 at a time `git clone --recurse-submodules -j4 git@github.com:nickpwhite/.dotfiles.git ~/.dotfiles`
2. `cd .dotfiles`
3. Install only bash's dotfiles, for example, with `stow bash`
4. Install terminal-only dotfiles with `stow $(ls -d */ | grep -v ^x-)`
3. Install all dotfiles with `stow $(ls -d */)`

### Extra installation steps
#### nvim
When opening nvim, run `:PlugUpdate` in order to install plugins.

## Updating
1. Change into the `.dotfiles` directory
2. `git pull`
3. Update all dotfiles with `stow -R $(ls -d */)`
4. Update only bash's dotfiles, for example, with `stow -R bash`

## Removing
1. Change into the `.dotfiles` directory
2. Remove all dotfiles with `stow -D $(ls -d */)`
3. Remove only bash's dotfiles, for example, with `stow -D bash`
