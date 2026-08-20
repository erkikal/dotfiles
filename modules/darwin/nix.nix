# System packages, nix settings, fonts and system-level shell/security.
{ pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    age
    bat
    btop
    carapace
    fastfetch
    jankyborders
    k9s
    lazysql
    mkalias
    neovim
    nh
    nvd
    sops
    starship
    vim
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
