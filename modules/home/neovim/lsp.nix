# Language servers, driven through nixvim's `lsp.servers` — which emits native
# `vim.lsp.config()` / `vim.lsp.enable()` rather than the deprecated
# `require('lspconfig')` API.
#
# Formatters and linters are not here; conform and nvim-lint own those in
# formatting.nix.
{ ... }:

{
  # The old config drove this through `require('mason-lspconfig').setup {
  # handlers = { ... } }`. mason-lspconfig v2 removed `handlers` entirely, so
  # every server setting in that block — including lua_ls's `callSnippet` — was
  # silently discarded; a live client reported `callSnippet = nil`. Mason is
  # gone now: the server binaries come from nixpkgs via `lsp.servers.*.package`,
  # and nixvim emits native `vim.lsp.config()` / `vim.lsp.enable()` calls.
  # nvim-lspconfig is still installed, but only as a data provider: it ships the
  # per-server default `cmd`, `filetypes` and `root_markers` that
  # `vim.lsp.config()` merges into. Nothing calls the deprecated
  # `require('lspconfig')` API — nixvim sets `callSetup = false` for it.
  plugins.lspconfig.enable = true;

  lsp = {
    servers = {
      lua_ls = {
        enable = true;
        # `config` is the `vim.lsp.config()` table, so settings nest under it.
        config.settings.Lua.completion.callSnippet = "Replace";
      };
      pyright.enable = true;
      # terraform-ls reads static configuration from `init_options`; it does not
      # support `settings`.
      terraformls.enable = true;

      # Advertised to every server. nvim-ufo needs this to get fold ranges from
      # the LSP; its module has a `setupLspCapabilities` option that would inject
      # it, but that writes into the *legacy* `plugins.lsp.capabilities`, which is
      # only read when `plugins.lsp.enable` is set — and this config uses the new
      # `lsp.servers` path instead. Declaring it here is what makes LSP folding
      # actually work rather than silently fall through to indent.
      "*".config.capabilities.textDocument.foldingRange = {
        dynamicRegistration = false;
        lineFoldingOnly = true;
      };
    };

    keymaps = [
      {
        key = "gd";
        action.__raw = "function() require('telescope.builtin').lsp_definitions() end";
        options.desc = "LSP: Goto definition";
      }
      {
        key = "gr";
        action.__raw = "function() require('telescope.builtin').lsp_references() end";
        options.desc = "LSP: Goto references";
      }
      {
        key = "gI";
        action.__raw = "function() require('telescope.builtin').lsp_implementations() end";
        options.desc = "LSP: Goto implementation";
      }
      {
        key = "<leader>D";
        action.__raw = "function() require('telescope.builtin').lsp_type_definitions() end";
        options.desc = "LSP: Type definition";
      }
      {
        key = "<leader>ds";
        action.__raw = "function() require('telescope.builtin').lsp_document_symbols() end";
        options.desc = "LSP: Document symbols";
      }
      {
        key = "<leader>ws";
        action.__raw = "function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end";
        options.desc = "LSP: Workspace symbols";
      }
      {
        key = "<leader>rn";
        lspBufAction = "rename";
        options.desc = "LSP: Rename";
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>ca";
        lspBufAction = "code_action";
        options.desc = "LSP: Code action";
      }
      {
        key = "gD";
        lspBufAction = "declaration";
        options.desc = "LSP: Goto declaration";
      }
    ];

    # Highlight other references to the symbol under the cursor while it rests
    # there, and the inlay-hint toggle. Both are capability-gated.
    #
    # `client:supports_method` — the colon form — is deliberate. The old config
    # used `client.supports_method(...)`, the dot form, which is deprecated and
    # removed in 0.13; it printed a warning on every single LSP attach.
    # nixvim calls this with `client`, `bufnr` and `event` already in scope.
    onAttach = ''
      if client:supports_method('textDocument/documentHighlight', bufnr) then
        local group = vim.api.nvim_create_augroup('nixvim-lsp-highlight', { clear = false })

        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = bufnr,
          group = group,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = bufnr,
          group = group,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          buffer = bufnr,
          group = vim.api.nvim_create_augroup('nixvim-lsp-detach', { clear = false }),
          callback = function(detach)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'nixvim-lsp-highlight', buffer = detach.buf }
          end,
        })
      end

      if client:supports_method('textDocument/inlayHint', bufnr) then
        vim.keymap.set('n', '<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
        end, { buffer = bufnr, desc = 'LSP: Toggle inlay hints' })
      end
    '';
  };

  # LSP progress in the corner, as before.
  plugins.fidget.enable = true;
}
