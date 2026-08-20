# btop — resource monitor.
#
# The Catppuccin Mocha theme is sourced from upstream (see catppuccin.nix for
# the pin) rather than inlined: the theme file is read into the `themes` option,
# which home-manager writes to $XDG_CONFIG_HOME/btop/themes/<name>.theme.
{ catppuccin, ... }:

{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin_mocha";
      theme_background = true;
      vim_keys = true;
    };
    themes = {
      catppuccin_mocha = builtins.readFile "${catppuccin.btop}/themes/catppuccin_mocha.theme";
    };
  };
}
