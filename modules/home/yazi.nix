# yazi — terminal file manager.
#
# The Catppuccin Mocha theme is sourced from upstream (see catppuccin.nix for
# the pins): the per-accent theme.toml is parsed and fed into
# `programs.yazi.theme` (written to $XDG_CONFIG_HOME/yazi/theme.toml). Pick a
# different accent by changing the filename below (see themes/mocha/*.toml).
#
# The upstream theme's `syntect_theme` (for code-preview syntax highlighting)
# points at a tmTheme it does not ship; catppuccin/yazi directs you to the bat
# repo for it, so we override it to the tmTheme we already fetch for bat.
{ catppuccin, lib, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "yy";

    theme = lib.recursiveUpdate
      (builtins.fromTOML (
        builtins.readFile "${catppuccin.yazi}/themes/mocha/catppuccin-mocha-sapphire.toml"
      ))
      {
        mgr.syntect_theme = "${catppuccin.bat}/themes/Catppuccin Mocha.tmTheme";
      };

    settings = {
      mgr = {
        show_hidden = true;
        sort_by = "natural";
        sort_sensitive = false;
        sort_dir_first = true;
        show_symlink = true;
      };
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = "l";
          run  = "plugin smart-enter";
          desc = "Enter the child directory, or open the file";
        }
        {
          on = "<Enter>";
          run = "plugin smart-enter";
          desc = "Enter the child directory, or open the file";
        }
        {
          on = [
            "g"
            "i"
          ];
          run = "plugin lazygit";
          desc = "run lazygit";
        }
      ];
    };
    plugins = {
      "lazygit" = pkgs.yaziPlugins.lazygit;
      "smart-enter" = pkgs.yaziPlugins.smart-enter;
    };
  };
}
