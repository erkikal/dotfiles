# Global keymaps, ported from lua/keymaps.lua plus the per-plugin `keys` specs
# that lazy.nvim used to own.
#
# Buffer-local maps are NOT here: the LSP ones are bound on attach (lsp.nix) and
# gitsigns binds its own inside `on_attach` (git.nix), because both need the
# buffer they attach to.
{ ... }:

{
  # ── lua/keymaps.lua ────────────────────────────────────────────────────────
  #
  # Dropped along the way, all bound to plugins that are not installed:
  #   <leader>a  :Alpha
  #   <S-q>      :Bdelete!
  #   <C-\>      :TZAtaraxis
  #   <leader>/  Comment.api      (mini.comment provides `gc`)
  #
  # Moved to stop shadowing a which-key group — in each case the old mapping
  # made you wait out `timeoutlen` before the group popup could appear:
  #   <leader>h  nohlsearch         -> <Esc>      ("Git [H]unk" group)
  #   <leader>s  substitute word    -> <leader>sR ("[S]earch" group)
  #   <leader>d  blackhole delete   -> <leader>x  ("[D]ocument" group)
  #   <leader>x  chmod +x           -> <leader>X  (displaced by the above)
  #   <leader>t  tabnew             -> <leader>tn ("[T]oggle" group)
  #   <leader>c  tabclose           -> <leader>tc ("[C]ode" group)
  keymaps = [
    # Window navigation
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options = {
        silent = true;
        desc = "Go to left window";
      };
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options = {
        silent = true;
        desc = "Go to lower window";
      };
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options = {
        silent = true;
        desc = "Go to upper window";
      };
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options = {
        silent = true;
        desc = "Go to right window";
      };
    }

    # Resize with arrows
    {
      mode = "n";
      key = "<C-Up>";
      action = "<cmd>resize -2<CR>";
      options = {
        silent = true;
        desc = "Shrink window height";
      };
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = "<cmd>resize +2<CR>";
      options = {
        silent = true;
        desc = "Grow window height";
      };
    }
    {
      mode = "n";
      key = "<C-Left>";
      action = "<cmd>vertical resize -2<CR>";
      options = {
        silent = true;
        desc = "Shrink window width";
      };
    }
    {
      mode = "n";
      key = "<C-Right>";
      action = "<cmd>vertical resize +2<CR>";
      options = {
        silent = true;
        desc = "Grow window width";
      };
    }

    # Keep the cursor put while moving around
    {
      mode = "n";
      key = "J";
      action = "mzJ`z";
      options.desc = "Join line, keep cursor position";
    }
    # The originals were written as 'C-d' -> 'C-d>zz': no angle brackets, so
    # they mapped the literal characters C, -, d rather than the scroll.
    {
      mode = "n";
      key = "<C-d>";
      action = "<C-d>zz";
      options.desc = "Scroll down, centre cursor";
    }
    {
      mode = "n";
      key = "<C-u>";
      action = "<C-u>zz";
      options.desc = "Scroll up, centre cursor";
    }
    {
      mode = "n";
      key = "n";
      action = "nzzzv";
      options.desc = "Next search result, centred";
    }
    {
      mode = "n";
      key = "N";
      action = "Nzzzv";
      options.desc = "Previous search result, centred";
    }

    # Buffers
    {
      mode = "n";
      key = "<S-l>";
      action = "<cmd>bnext<CR>";
      options = {
        silent = true;
        desc = "Next buffer";
      };
    }
    {
      mode = "n";
      key = "<S-h>";
      action = "<cmd>bprevious<CR>";
      options = {
        silent = true;
        desc = "Previous buffer";
      };
    }

    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options = {
        silent = true;
        desc = "Clear search highlight";
      };
    }
    {
      mode = "n";
      key = "<leader>sR";
      action = ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left><C-w>";
      options.desc = "Substitute word under cursor";
    }
    {
      mode = "n";
      key = "<leader>X";
      action = "<cmd>!chmod +x %<CR>";
      options = {
        silent = true;
        desc = "Make file executable";
      };
    }

    # Yank / paste / delete against the right registers
    {
      mode = "v";
      key = "p";
      action = ''"_dP'';
      options = {
        silent = true;
        desc = "Paste without clobbering the register";
      };
    }
    {
      mode = "x";
      key = "<leader>p";
      action = ''"_dP'';
      options.desc = "Paste without clobbering the register";
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>y";
      action = ''"+y'';
      options.desc = "Yank to system clipboard";
    }
    {
      mode = "n";
      key = "<leader>Y";
      action = ''"+Y'';
      options.desc = "Yank line to system clipboard";
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>x";
      action = ''"_d'';
      options.desc = "Delete to black hole";
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>c";
      action = ''"_c'';
      options.desc = "Change without messing up the registry";
    }

    {
      mode = "n";
      key = "<leader><leader>";
      action = "<cmd>source %<CR>";
      options.desc = "Source the current file";
    }
    {
      mode = "i";
      key = "jj";
      action = "<Esc>";
      options = {
        silent = true;
        desc = "Leave insert mode";
      };
    }

    # Stay in visual mode when indenting
    {
      mode = "v";
      key = "<";
      action = "<gv";
      options = {
        silent = true;
        desc = "Indent left, keep selection";
      };
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
      options = {
        silent = true;
        desc = "Indent right, keep selection";
      };
    }

    {
      mode = "n";
      key = "<leader>e";
      action = "$";
      options = {
        silent = true;
        desc = "Go to end of line";
      };
    }

    # Tabs
    {
      mode = "n";
      key = "<leader>1";
      action = "1gt";
      options = {
        silent = true;
        desc = "Go to tab 1";
      };
    }
    {
      mode = "n";
      key = "<leader>2";
      action = "2gt";
      options = {
        silent = true;
        desc = "Go to tab 2";
      };
    }
    {
      mode = "n";
      key = "<leader>3";
      action = "3gt";
      options = {
        silent = true;
        desc = "Go to tab 3";
      };
    }
    {
      mode = "n";
      key = "<leader>4";
      action = "4gt";
      options = {
        silent = true;
        desc = "Go to tab 4";
      };
    }
    {
      mode = "n";
      key = "<leader>5";
      action = "5gt";
      options = {
        silent = true;
        desc = "Go to tab 5";
      };
    }
    {
      mode = "n";
      key = "<leader>tn";
      action = "<cmd>tabnew<CR>";
      options = {
        silent = true;
        desc = "New tab";
      };
    }
    {
      mode = "n";
      key = "<leader>tc";
      action = "<cmd>tabclose<CR>";
      options = {
        silent = true;
        desc = "Close tab";
      };
    }

    # Diagnostics. `vim.diagnostic.goto_prev`/`goto_next` are deprecated since
    # 0.11 in favour of `vim.diagnostic.jump`.
    {
      mode = "n";
      key = "[d";
      action.__raw = ''
        function()
          vim.diagnostic.jump { count = -1, float = true }
        end
      '';
      options.desc = "Go to previous diagnostic";
    }
    {
      mode = "n";
      key = "]d";
      action.__raw = ''
        function()
          vim.diagnostic.jump { count = 1, float = true }
        end
      '';
      options.desc = "Go to next diagnostic";
    }
    {
      mode = "n";
      key = "<leader>E";
      action.__raw = "vim.diagnostic.open_float";
      options.desc = "Open floating diagnostic";
    }
    {
      mode = "n";
      key = "<leader>q";
      action.__raw = "vim.diagnostic.setloclist";
      options.desc = "Open diagnostics list";
    }

    # ── Plugin keymaps ───────────────────────────────────────────────────────
    #
    # Everything below belongs to a plugin configured further down: the entries
    # that need an argument, a Lua closure or a plugin command, and so don't fit
    # `plugins.telescope.keymaps` (which takes only a builtin's bare name).
    #
    # These are plain global keymaps rather than `keymapsOnEvents`: that option
    # binds with `buffer = args.buf`, so the mappings would exist only in
    # whichever buffer was current when the event fired.

    # Telescope, with arguments.
    {
      mode = "n";
      key = "<leader>/";
      action.__raw = ''
        function()
          require('telescope.builtin').current_buffer_fuzzy_find(
            require('telescope.themes').get_dropdown {
              winblend = 10,
              previewer = false,
            }
          )
        end
      '';
      options.desc = "Fuzzily search in current buffer";
    }
    {
      mode = "n";
      key = "<leader>s/";
      action.__raw = ''
        function()
          require('telescope.builtin').live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end
      '';
      options.desc = "Search in open files";
    }
    {
      mode = "n";
      key = "<leader>sn";
      action.__raw = ''
        function()
          require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
        end
      '';
      options.desc = "Search Neovim config files";
    }
    {
      mode = "n";
      key = "<leader>fe";
      action = "<cmd>Telescope file_browser<CR>";
      options = {
        silent = true;
        desc = "File browser";
      };
    }
    # Was `:Telescope zoxide list`. project.nvim is dropped; zoxide's own
    # frecency list is what this keymap actually used.
    {
      mode = "n";
      key = "<leader>fp";
      action = "<cmd>Telescope zoxide list<CR>";
      options = {
        silent = true;
        desc = "Find project (zoxide)";
      };
    }

    # snacks.nvim. The old spec reached these through a bare global `Snacks` that
    # its own `init` assigned; requiring the module keeps them independent of
    # load order.
    {
      mode = "n";
      key = "<leader>nd";
      action.__raw = "function() require('snacks').notifier.hide() end";
      options.desc = "Dismiss all notifications";
    }
    {
      mode = "n";
      key = "<leader>gg";
      action.__raw = "function() require('snacks').lazygit() end";
      options.desc = "Lazygit";
    }
    {
      mode = "n";
      key = "<leader>gb";
      action.__raw = "function() require('snacks').git.blame_line() end";
      options.desc = "Git blame line";
    }

    # git / files
    {
      mode = "n";
      key = "<leader>gs";
      action.__raw = "vim.cmd.Git";
      options.desc = "Git status (fugitive)";
    }
    {
      mode = "n";
      key = "<leader>gy";
      action = "<cmd>Yazi<CR>";
      options = {
        silent = true;
        desc = "Toggle Yazi";
      };
    }
    {
      mode = "n";
      key = "<leader>uu";
      action = "<cmd>UndotreeToggle<CR><cmd>UndotreeFocus<CR>";
      options = {
        silent = true;
        desc = "Toggle undotree";
      };
    }

    # Folding. The old spec called `ufo.closeAllFolds()` against an undefined
    # global `ufo`, so both keymaps errored on every press.
    {
      mode = "n";
      key = "zm";
      action.__raw = "function() require('ufo').closeAllFolds() end";
      options.desc = "Close all folds";
    }
    {
      mode = "n";
      key = "zR";
      action.__raw = "function() require('ufo').openAllFolds() end";
      options.desc = "Open all folds";
    }

    # Markdown / notes.
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>mp";
      action = "<cmd>MarkdownPreviewToggle<CR>";
      options = {
        silent = true;
        desc = "Toggle markdown preview";
      };
    }
    {
      mode = "n";
      key = "<leader>mh";
      action = "<cmd>Markview hybridToggle<CR>";
      options = {
        silent = true;
        desc = "Toggle markview hybrid mode";
      };
    }
    {
      mode = "n";
      key = "<leader>ms";
      action = "<cmd>Markview splitToggle<CR>";
      options = {
        silent = true;
        desc = "Toggle markview split view";
      };
    }
    # obsidian.nvim dropped its `mappings` option, so these are ordinary keymaps
    # now. The fork also auto-maps <CR> to a smart action covering both of these
    # in a markdown buffer; they are kept because the muscle memory is what it is.
    {
      mode = "n";
      key = "<leader>mf";
      action.__raw = "function() return require('obsidian').util.gf_passthrough() end";
      options = {
        desc = "Follow Obsidian link";
        remap = true;
        expr = true;
      };
    }
    {
      mode = "n";
      key = "<leader>md";
      action.__raw = "function() return require('obsidian').util.toggle_checkbox() end";
      options.desc = "Toggle Obsidian checkbox";
    }
  ];
}
