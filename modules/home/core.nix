# Base home-manager settings: identity, packages, environment, nh.
{ config, pkgs, ... }:

{
  home = {
    username = "erkik";
    homeDirectory = "/Users/erkik";
    stateVersion = "25.05"; # Please read the comment before changing.

    # Makes sense for user specific applications that shouldn't be available system-wide
    packages = with pkgs; [
      atuin
    ];

    sessionVariables = {
      AWS_DEFAULT_REGION = "eu-north-1";
      XDG_CONFIG_HOME = "$HOME/.config";

      EDITOR = "nvim";
      VISUAL = "nvim";
      LANG = "en_US.UTF-8";

      LS_COLORS = "$(vivid generate catppuccin-mocha)";

      OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES";

      WORDCHARS = "*?.[]~=&;!#$%^(){}<>";
    };

    sessionPath = [
      "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
      "$HOME/.rd/bin"
      "$HOME/.local/bin"
    ];
  };

  programs = {
    home-manager.enable = true;

    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 10";
      };
      flake = "${config.home.homeDirectory}/github/dotfiles";
    };
  };
}
