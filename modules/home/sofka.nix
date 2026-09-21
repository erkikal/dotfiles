# sofka — Kubernetes TUI.
#
# The package comes from the flake's `sofka` input rather than nixpkgs, which
# does not carry it. The input's home-manager module defines programs.sofka and
# is registered in the host's home-manager.sharedModules.
#
# sofka carries every Catppuccin flavor as a built-in palette, so naming one is
# the whole theme setup — no upstream skin source to pin in catppuccin.nix.
{ ... }:

{
  programs.sofka = {
    enable = true;
    skin.name = "catppuccin-mocha";
  };
}
