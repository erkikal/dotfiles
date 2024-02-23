# dotfiles

Collection of my dotfiles

## Prerequisites

Some of the plugins are pulled in as submodules, make sure they are present and up to date.

Packages used need to be sourced manually for now, automated setup is WIP

Necessary packages:
- neovim
- starship
- zoxide
- fzf
- eza
- github cli (gh)
- lazygit

## Usage

- Clone the repo to where you want the dotfiles to live.

```bash
git clone --recursive https://github.com/erkikal/dotfiles.git
```

- Run the install script

```bash
./install
```

- Optionally with a custom install config

```bash
./install -c install.remote.conf.yaml
```

- ...

- Profit?
