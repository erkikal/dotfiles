# home.nix
# home-manager switch 

{ config, pkgs, ... }:

{
  home.username = "erkikal";
  home.homeDirectory = "/Users/erkikal";
  home.stateVersion = "24.05"; # Please read the comment before changing.

# Makes sense for user specific applications that shouldn't be available system-wide
  home.packages = [
  ];

  # Home Manager is pretty good at managing github/dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".zshrc".source = ~/github/dotfiles/zshrc/.zshrc;
    ".config/wezterm".source = ~/github/dotfiles/wezterm;
    ".config/starship".source = ~/github/dotfiles/starship;
    ".config/zellij".source = ~/github/dotfiles/zellij;
    ".config/nvim".source = ~/github/dotfiles/neovim;
    ".config/nix".source = ~/github/dotfiles/nix;
    ".config/nix-darwin".source = ~/github/dotfiles/nix-darwin;
    # ".config/tmux".source = ~/github/dotfiles/tmux;
  };

  home.sessionVariables = {
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
  ];
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    initExtra = ''
      # Add any additional configurations here
      export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';
  };
}
