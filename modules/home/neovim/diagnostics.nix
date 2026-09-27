# Diagnostic presentation, and trouble.nvim as the list view for them.
{...}: {
  # `vim.diagnostic.config`. Neovim's defaults show virtual text unprefixed and
  # unsorted, so a hint and an error on the same line are indistinguishable at a
  # glance and arrive in whatever order the server sent them.
  #
  # `update_in_insert` is deliberately left off (default `false`): re-running
  # diagnostics on every keystroke means half-typed lines flash errors that
  # resolve themselves a character later.
  diagnostic.settings = {
    virtual_text = {
      prefix = "●";
      spacing = 2;
    };
    severity_sort = true;
    underline = true;
    signs = true;
  };

  # A real list for diagnostics, references and quickfix. Nothing filled that
  # role before — `[d` / `]d` walked diagnostics one at a time with no overview.
  plugins.trouble = {
    enable = true;
    settings.focus = true;
  };

  # Under `<leader>l`, not `<leader>x` or `<leader>d`. `<leader>x` is already the
  # black-hole delete operator in normal and visual mode, so `<leader>xx` would
  # leave it waiting on `timeoutlen` for a second `x`; `<leader>d` is the
  # [D]ocument group. `<leader>l` was unused.
  keymaps = [
    {
      mode = "n";
      key = "<leader>ll";
      action = "<cmd>Trouble diagnostics toggle<CR>";
      options.desc = "Diagnostics (workspace)";
    }
    {
      mode = "n";
      key = "<leader>lb";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
      options.desc = "Diagnostics (buffer)";
    }
    {
      mode = "n";
      key = "<leader>ls";
      action = "<cmd>Trouble symbols toggle<CR>";
      options.desc = "Symbols";
    }
    {
      mode = "n";
      key = "<leader>lr";
      action = "<cmd>Trouble lsp toggle<CR>";
      options.desc = "LSP references / definitions";
    }
    {
      mode = "n";
      key = "<leader>lq";
      action = "<cmd>Trouble qflist toggle<CR>";
      options.desc = "Quickfix list";
    }
    {
      mode = "n";
      key = "<leader>lL";
      action = "<cmd>Trouble loclist toggle<CR>";
      options.desc = "Location list";
    }
    # The float for the diagnostic under the cursor. `<leader>dl` in the source
    # config; `<leader>d` is our [D]ocument group, so it moves here with the rest.
    {
      mode = "n";
      key = "<leader>le";
      action.__raw = "function() vim.diagnostic.open_float() end";
      options.desc = "Diagnostic float";
    }
  ];
}
