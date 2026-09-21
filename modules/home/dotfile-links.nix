# Links raw app configs from this repo into $HOME / $XDG_CONFIG_HOME.
#
# Two strategies:
#   * Path literals (../../foo) are copied into the Nix store — reproducible,
#     but require a rebuild to pick up edits.
#   * mkOutOfStoreSymlink points at the live checkout — edits apply instantly,
#     and is required for configs the app itself writes back to (nvim, raycast).
{ config, ... }:

let
  dotfiles = "${config.home.homeDirectory}/github/dotfiles";
in
{
  home.file.".zsh".source = ../../zsh;

  xdg.configFile = {
    # "wezterm".source = ../../wezterm;
    # ghostty config is managed by programs.ghostty (see ghostty.nix).
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/neovim/erki-kickstart";
    "nix".source = ../../nix;
    "kanata".source = ../../kanata;
    "raycast".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/raycast";
    "sketchybar".source = ../../sketchybar;
  };
}
