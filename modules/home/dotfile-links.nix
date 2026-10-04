# Links raw app configs from this repo into $XDG_CONFIG_HOME.
#
# The sources are path literals (../../foo), so Nix copies them into the store:
# reproducible, but an edit needs a rebuild to take effect.
#
# Everything else this repo used to link is now generated from a module under
# modules/home instead — these are the configs no home-manager module covers.
# The last holdout, a whole-directory link of zsh/ carrying two hand-copied
# oh-my-zsh plugins, is gone: see zsh-plugins.nix, which declares them from
# pkgs.oh-my-zsh and owns ~/.zsh/plugins itself.
{...}: {
  xdg.configFile = {
    "kanata".source = ../../kanata;
    "sketchybar".source = ../../sketchybar;
  };
}
