# Links raw app configs from this repo into $HOME / $XDG_CONFIG_HOME.
#
# The sources are path literals (../../foo), so Nix copies them into the store:
# reproducible, but an edit needs a rebuild to take effect.
#
# Everything else this repo used to link is now generated from a module under
# modules/home instead — these are the configs no home-manager module covers.
{...}: {
  home.file.".zsh".source = ../../zsh;

  xdg.configFile = {
    "kanata".source = ../../kanata;
    "sketchybar".source = ../../sketchybar;
  };
}
