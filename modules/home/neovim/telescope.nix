# Telescope and its extensions.
#
# `enable` is set here, but note the LSP keymaps in lsp.nix resolve through
# Telescope's pickers, so this is not an optional plugin.
{ ... }:

{
  # fzf-native needed `build = 'make'` plus a `cond` on `vim.fn.executable
  # 'make'` under lazy.nvim; Nix builds the native library at package time, so
  # both are gone.
  plugins.telescope = {
    enable = true;

    extensions = {
      fzf-native.enable = true;
      # The old config wrapped `get_dropdown()` in a list, which telescope reads
      # as the positional `extensions['ui-select'][1]`. nixvim generates the
      # attrset directly. `enable` is separate from `settings` — setting only the
      # latter configures an extension that was never installed.
      ui-select = {
        enable = true;
        settings.__raw = "require('telescope.themes').get_dropdown()";
      };
      file-browser.enable = true;
      zoxide.enable = true;
    };

    settings.defaults.mappings.i = {
      # Leave <C-u>/<C-d> as their terminal defaults rather than telescope's
      # preview scroll, as before.
      "<C-u>" = false;
      "<C-d>" = false;
    };

    # Note this is an attrset keyed by the mapping, unlike the top-level
    # `keymaps` list — each value names a telescope builtin.
    keymaps = {
      "<leader>sh" = {
        action = "help_tags";
        options.desc = "Search help";
      };
      "<leader>sk" = {
        action = "keymaps";
        options.desc = "Search keymaps";
      };
      "<leader>sf" = {
        action = "find_files";
        options.desc = "Search files";
      };
      "<leader>ss" = {
        action = "builtin";
        options.desc = "Search telescope pickers";
      };
      "<leader>sw" = {
        action = "grep_string";
        options.desc = "Search current word";
      };
      "<leader>sg" = {
        action = "live_grep";
        options.desc = "Search by grep";
      };
      "<leader>sd" = {
        action = "diagnostics";
        options.desc = "Search diagnostics";
      };
      "<leader>sr" = {
        action = "resume";
        options.desc = "Resume last search";
      };
      "<leader>s." = {
        action = "oldfiles";
        options.desc = "Search recent files";
      };
      # The `<leader>f*` set from the old keymaps.lua, which used `:Telescope
      # <picker><CR>` command strings. Going through `keymaps` gives the same
      # pickers plus a description which-key can show.
      "<leader>ff" = {
        action = "find_files";
        options.desc = "Find files";
      };
      "<leader>ft" = {
        action = "live_grep";
        options.desc = "Find text";
      };
      "<leader>fb" = {
        action = "buffers";
        options.desc = "Find buffers";
      };
    };
  };
}
