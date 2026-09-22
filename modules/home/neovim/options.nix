# Editor options, globals and filetype autocommands.
#
# Ported from the old config's init.lua (globals) and lua/options.lua (the rest).
{ ... }:

{
  # ── init.lua ───────────────────────────────────────────────────────────────
  globals = {
    mapleader = " ";
    maplocalleader = " ";
    # netrw is unused; yazi and telescope-file-browser cover file browsing.
    loaded_netrw = 1;
    loaded_netrwPlugin = 1;
    have_nerd_font = true;
  };

  # ── lua/options.lua ────────────────────────────────────────────────────────
  opts = {
    number = true;
    relativenumber = true;
    hlsearch = false;
    mouse = "a";
    # The mode is in the statusline already.
    showmode = false;
    breakindent = true;
    smartindent = true;

    # nvim-ufo has no saved fold level of its own — the fold commands that would
    # normally restore one (zr/zm) have no ufo equivalent — so the vim-internal
    # levels are pinned wide open and ufo drives folding entirely.
    foldlevel = 99;
    foldlevelstart = 99;
    undofile = true;
    # Case-insensitive unless the pattern contains \C or a capital.
    ignorecase = true;
    smartcase = true;
    signcolumn = "yes";
    updatetime = 250;
    # Shows the which-key popup sooner.
    timeoutlen = 300;
    splitright = true;
    splitbelow = true;
    list = true;
    listchars = {
      tab = "» ";
      trail = "·";
      nbsp = "␣";
    };
    inccommand = "split";
    cursorline = true;
    completeopt = "menuone,noselect";
    termguicolors = true;
    tabstop = 2;
    shiftwidth = 2;
    expandtab = true;
    # Obsidian and markview both need a non-zero conceallevel.
    conceallevel = 1;
    scrolloff = 10;

    # `undodir` is deliberately not set: the old config pointed it at
    # ~/.vim/undodir, but Neovim's default (stdpath("state")/undo) is already
    # correct and needs no directory created by hand.
    #
    # `spell` is deliberately not set here either. It used to be global, which
    # meant spellcheck in every code buffer; it is scoped by filetype below.
  };

  clipboard.register = "unnamedplus";

  autoGroups.nixvim-spell.clear = true;

  autoCmd = [
    {
      # Replaces the old global `vim.opt.spell = true`.
      event = "FileType";
      group = "nixvim-spell";
      pattern = [
        "markdown"
        "text"
        "gitcommit"
      ];
      desc = "Enable spellcheck in prose buffers only";
      callback.__raw = ''
        function()
          vim.opt_local.spell = true
        end
      '';
    }
  ];
}
