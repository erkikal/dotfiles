# The nixvim configuration, split by concern across the files imported below.
# ./default.nix imports this into `programs.nixvim`.
#
# Ported from the kickstart config at neovim/erki-kickstart, which was itself
# modularized under lua/. Where the port deviates from the original, a comment
# in the relevant file says why — most of those are bugs the Lua config had been
# running with silently.
#
# The split follows the old layout's spirit rather than its letter: one file per
# thing that needed real configuration, and plugins.nix for everything that is
# just `enable` (or a line or two more). It is a plain module-system `imports`,
# so nixvim's options merge across the files — `extraConfigLua` is
# `types.lines` and `keymaps` is a list, which is why the snippets each plugin
# needs can live next to that plugin instead of in one shared tail.
#
# Global keymaps are collected in keymaps.nix, as they were in lua/keymaps.lua.
# Buffer-local ones stay with their plugin: LSP binds on attach and gitsigns
# inside `on_attach`, since both need the buffer.
{ ... }:

{
  imports = [
    ./options.nix
    ./colorscheme.nix
    ./keymaps.nix

    ./lsp.nix
    ./completion.nix
    ./formatting.nix
    ./treesitter.nix

    ./telescope.nix
    ./git.nix
    ./which-key.nix
    ./mini.nix
    ./snacks.nix
    ./folding.nix
    ./markdown.nix

    ./plugins.nix
  ];
}
