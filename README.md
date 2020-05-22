# .dotfiles
My dotfiles are managed with [GNU stow](https://www.gnu.org/software/stow/).

## Installation
1. Clone the repository into ~ `git clone git@github.com:nickpwhite/.dotfiles.git`
2. `cd .dotfiles`
3. Install all dotfiles with `stow $(ls -d */)`
4. Install only bash's dotfiles, for example, with `stow bash`

## Updating
1. Change into the `.dotfiles` directory
2. `git pull`
3. Update all dotfiles with `stow -R $(ls -d */)`
4. Update only bash's dotfiles, for example, with `stow -R bash`

## Removing
1. Change into the `.dotfiles` directory
2. Remove all dotfiles with `stow -D $(ls -d */)`
3. Remove only bash's dotfiles, for example, with `stow -D bash`
