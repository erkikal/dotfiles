# dotfiles

My macOS configuration, built with [nix-darwin](https://github.com/nix-darwin/nix-darwin)
and [home-manager](https://github.com/nix-community/home-manager). One host:
`erkik-mac-2`.

Almost everything is declared in Nix. Neovim comes from
[nixvim](https://github.com/nix-community/nixvim), GUI apps and a few CLI tools
from Homebrew (declared, not installed by hand), and secrets from
[sops-nix](https://github.com/Mic92/sops-nix).

## Prerequisites

- The [Nix package manager](https://nixos.org/download/)
- An age key at `~/.config/sops/age/keys.txt`, for the encrypted files under
  `secrets/`. Without it the config still builds, but the Claude Code gateway
  variables stay unset.

## Usage

```bash
git clone https://github.com/erkikal/dotfiles.git ~/github/dotfiles
cd ~/github/dotfiles
```

The hostname in `flake.nix` has to match the machine. Check it with
`scutil --get LocalHostName`.

First build, before the config is installed:

```bash
nix run nix-darwin#darwin-rebuild -- switch --flake .#erkik-mac-2
```

Afterwards:

```bash
darwin-rebuild switch --flake .#erkik-mac-2
```

or use the aliases the config itself defines: `nos` to dry-run and `nosa` to
switch (both `nh darwin switch`), `ndiff` to see what changed.

## Layout

| Path | What |
|---|---|
| `flake.nix` | Inputs and the `erkik-mac-2` darwin configuration |
| `hosts/erkik-mac-2/` | Composition root — wires the modules, sets host identity |
| `modules/darwin/` | System level: nix settings, Homebrew, macOS defaults, fonts |
| `modules/home/` | Per-app home-manager modules, one file per app |
| `modules/home/neovim/` | The nixvim config, split by concern |
| `secrets/` | sops-encrypted secrets |
| `kanata/`, `sketchybar/` | The only raw configs left — no home-manager module covers them, so `modules/home/dotfile-links.nix` links them into `~/.config` |
| `zsh/` | The `git` and `kubectl` completion plugins, sourced by `modules/home/zsh.nix` |

Everything else an app needs is generated from its module, so
`~/.config/<app>` is a symlink into the Nix store. Edit the module, not the
generated file.
