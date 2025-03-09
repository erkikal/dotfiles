# dotfiles

Collection of my dotfiles

## Prerequisites

Some of the plugins are pulled in as submodules, make sure they are present and up to date.

Some manual steps/packages are needed:

- Install (Nix package manager)[https://nixos.org/download/]
- Set up (nix-darwin)[https://github.com/LnL7/nix-darwin]

```bash
# To use Nixpkgs unstable:
nix run nix-darwin/master#darwin-rebuild -- switch
# To use Nixpkgs 24.11:
nix run nix-darwin/nix-darwin-24.11#darwin-rebuild -- switch
```

- (Set up homebrew)

## Usage

- Clone the repo to where you want the dotfiles to live.

```bash
git clone --recursive https://github.com/erkikal/dotfiles.git
```

- Make sure to have the correct hostname in `flake.nix` and username in `home.nix`

```bash
scutil --get LocalHostName
```

- Run the rebuild command and watch the magic happen
  - `--impure` flag is required due to allowing neovim config to be loaded impurely - so that config changes don't require rebuilding

```bash
darwin-rebuild switch --flake flake.nix --impure
```

------

<details><summary>Old dotbot config</summary>
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

```bash
./install -p dotbot-brew
```

```bash
./install -p dotbot-nix-env
```

- Optionally with a custom install config

```bash
./install -c install.headless.conf.yaml
```

- ...

- Profit?
</details>
