# bat — cat with syntax highlighting.
#
# Catppuccin Mocha theme sourced from upstream (see catppuccin.nix for the pin).
{ catppuccin, ... }:

{
  programs.bat = {
    enable = true;
    config = {
      theme = "catppuccin";
    };
    themes = {
      catppuccin = {
        src = catppuccin.bat;
        file = "themes/Catppuccin Mocha.tmTheme";
      };
    };
  };
}
