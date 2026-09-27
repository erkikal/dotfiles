# Neovim, configured declaratively with nixvim.
#
# This replaces the old lazy.nvim kickstart config (the `neovim` submodule, linked
# into place by dotfile-links.nix). Building it through Nix fixes a class of failure
# the Lua config was prone to: a misplaced or misspelled option is an evaluation
# error here, where lazy.nvim would silently ignore it. Language servers, formatters
# and linters come from nixpkgs, so Mason is neither needed nor used.
#
# The configuration itself is split by concern across the files that ./config.nix
# imports — one per plugin or area that needed real configuration, plus a shared
# plugins.nix for the enable-only ones.
#
# This module owns ~/.config/nvim: the home-manager module writes
# xdg.configFile."nvim/init.lua", so nothing else may link that directory.
#
# `defaultEditor` is deliberately not set — core.nix already points EDITOR and
# VISUAL at nvim, and setting it here would be a second definition of
# home.sessionVariables.EDITOR.
#
# `viAlias`/`vimAlias` need `vim` gone from environment.systemPackages: core.nix
# puts /run/current-system/sw/bin ahead of ~/.nix-profile/bin in sessionPath, so
# a system `vim` would win over the alias. It was removed from
# modules/darwin/nix.nix, along with the duplicate `vim = "nvim"` shell alias in
# zsh.nix that the aliases now supersede.
{ inputs, pkgs, ... }:

{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;

    # `vi` and `vim` both launch this nvim. Muscle memory aside, it matters for
    # anything that shells out to `vi` by name rather than reading $EDITOR.
    viAlias = true;
    vimAlias = true;

    # Reuse the host's package set rather than letting nixvim import its own from
    # `nixpkgs.source`. Since nixvim's nixpkgs input `follows` ours, evaluating it
    # twice would only be slower; it also silences nixvim's warning that our
    # `follows` moved its pinned revision.
    nixpkgs.pkgs = pkgs;

    imports = [ ./config.nix ];
  };
}
