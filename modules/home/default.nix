# Aggregates all home-manager modules for user `erkik`.
{ ... }:

{
  imports = [
    ./catppuccin.nix
    ./core.nix
    ./dotfile-links.nix
    ./zsh.nix
    ./git.nix
    ./starship.nix
    ./atuin.nix
    ./bat.nix
    ./carapace.nix
    ./lazysql.nix
    ./sofka.nix
    ./yazi.nix
    ./neovim
    ./zoxide.nix
    ./btop.nix
    ./fastfetch.nix
    ./jankyborders.nix
    ./ghostty.nix
    ./claude.nix
    ./herdr.nix
    ./sops.nix
  ];
}
