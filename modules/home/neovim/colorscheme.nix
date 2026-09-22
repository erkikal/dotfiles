# Catppuccin, the colorscheme.
{ ... }:

{
  # In the lazy.nvim spec `flavour` and `integrations` sat at the top level
  # instead of inside `opts`, so both were ignored and the flavour stayed
  # `auto`. Here a misplaced key is an evaluation error.
  colorschemes.catppuccin = {
    enable = true;
    settings = {
      flavour = "mocha";
      integrations = {
        gitsigns = true;
        blink_cmp = true;
        mini.enabled = true;
        snacks.enabled = true;
        telescope.enabled = true;
        which_key = true;
        treesitter = true;
        markdown = true;
        native_lsp.enabled = true;
        illuminate.enabled = true;
      };

      # The old config did this as `vim.cmd.hi 'Comment gui=none'`. Going
      # through catppuccin's own option rather than `highlightOverride` is
      # deliberate: `highlightOverride` calls `nvim_set_hl`, which *replaces*
      # the group, so clearing the italics that way also discards the
      # foreground colour and comments render unhighlighted.
      #
      # Written as raw `{}` rather than `[ ]` because nixvim prunes empty lists
      # out of the generated `setup{}` call, which would silently leave the
      # italic default in place. `[ "NONE" ]` is not an alternative: catppuccin
      # passes these strings through as `nvim_set_hl` keys, and "NONE" is not
      # one, so it errors on every startup.
      styles.comments.__raw = "{}";
    };
  };
}
