# System packages, nix settings, fonts and system-level shell/security.
{ pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  #
  # No `vim` here: nixvim provides `vi` and `vim` as aliases for nvim
  # (modules/home/neovim/default.nix), and this profile comes first on PATH, so a
  # system vim would shadow them.
  environment.systemPackages = with pkgs; [
    age
    bat
    btop
    carapace
    fastfetch
    jankyborders
    lazysql
    mkalias
    nh
    nvd
    sops
    starship
    vivid
    yazi
    zoxide
  ];

  fonts.packages = [
    pkgs.nerd-fonts.terminess-ttf
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh = {
    enable = true; # default shell on catalina
    enableSyntaxHighlighting = true;
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}
