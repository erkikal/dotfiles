# Base home-manager settings: identity, packages, environment, nh.
{ config, lib, pkgs, ... }:

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
      clean.enable = true;
      flake = "${config.home.homeDirectory}/github/dotfiles";
    };
  };

  # The nh module hands `clean.extraArgs` to launchd as a single argv element,
  # so "--keep-since 7d --keep 10" arrived as one string and nh aborted with
  # `unexpected argument` on every scheduled run. Pass the flags as separate
  # arguments instead, and leave extraArgs unset so there is one source of
  # truth. (Linux is unaffected: systemd word-splits its ExecStart string.)
  launchd.agents.nh-clean.config.ProgramArguments = lib.mkForce [
    (lib.getExe config.programs.nh.package)
    "clean"
    "user"
    "--keep-since"
    "7d"
    "--keep"
    "10"
  ];
}
