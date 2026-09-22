# Plugins that need no configuration beyond `enable`, or a line or two of it.
#
# Anything needing more than that lives in its own file alongside this one.
{ ... }:

{
  # ── Editing / navigation extras ────────────────────────────────────────────
  plugins.todo-comments = {
    enable = true;
    settings.signs = false;
  };

  plugins.illuminate.enable = true;
  plugins.undotree.enable = true;
  plugins.web-devicons.enable = true;
  # `tpope/vim-sleuth` — nixvim calls the module `sleuth`.
  plugins.sleuth.enable = true;
  # `lambdalisue/suda.vim` — nixvim calls the module `vim-suda`.
  plugins.vim-suda.enable = true;

  # The old spec was `opts = {}`, so noice's own defaults are what was running.
  plugins.noice.enable = true;
  plugins.notify.enable = true;

  # ── yazi ───────────────────────────────────────────────────────────────────
  #
  # `DreamMaoMao/yazi.nvim` was archived in mid-2024; this is
  # `mikavilpas/yazi.nvim` (nixpkgs' `yazi-nvim`), the maintained plugin of that
  # name. The `:Yazi` command and the `<leader>gy` binding carry over unchanged.
  plugins.yazi.enable = true;
}
