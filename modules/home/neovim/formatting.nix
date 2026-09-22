# Format-on-save (conform) and linting (nvim-lint).
#
# Both were silently dead in the old config: neither `stylua` nor `markdownlint`
# was on $PATH, and conform's `notify_on_error = false` swallowed the complaint.
# nixvim installs the packages named in `formatters_by_ft` and `lintersByFt`
# alongside the config, so this cannot drift out of sync again.
{ ... }:

{
  # ── Formatting ─────────────────────────────────────────────────────────────
  plugins.conform-nvim = {
    enable = true;
    # Opt-in, and the whole point of moving off Mason: this is what puts the
    # formatters named below onto Neovim's PATH.
    autoInstall = {
      enable = true;
      # nixvim maps `terraform_fmt` to `tenv`, a version-manager shim. Putting
      # it on the PATH shadows the real terraform (Homebrew's, per
      # modules/darwin/homebrew.nix) with one that has no version installed and
      # refuses to fetch one, so `terraform fmt` fails — and terraform-ls,
      # which shells out to the same binary, fails with it. `null` keeps the
      # package off the PATH and lets both find the working terraform.
      overrides.terraform_fmt = null;
    };
    settings = {
      notify_on_error = false;
      # A callback rather than a table because the old config disabled
      # format-on-save for c/cpp, where there is no standardised style.
      format_on_save.__raw = ''
        function(bufnr)
          local disable_filetypes = { c = true, cpp = true }
          if disable_filetypes[vim.bo[bufnr].filetype] then
            return nil
          end
          return { timeout_ms = 500, lsp_format = 'fallback' }
        end
      '';
      formatters_by_ft = {
        lua = [ "stylua" ];
        # Replaces the old `*.tf`/`*.tfvars` BufWritePre autocmd. That one was
        # created inside the LspAttach callback with no `buffer` scoping, so it
        # re-registered itself globally on every attach.
        terraform = [ "terraform_fmt" ];
        hcl = [ "terraform_fmt" ];
      };
    };
  };

  # ── Linting ────────────────────────────────────────────────────────────────
  plugins.lint = {
    enable = true;
    autoInstall.enable = true;
    lintersByFt.markdown = [ "markdownlint" ];
    autoCmd = {
      event = [
        "BufEnter"
        "BufWritePost"
        "InsertLeave"
      ];
      # Only lint buffers you could actually fix, as before.
      callback.__raw = ''
        function()
          if vim.bo.modifiable then
            require('lint').try_lint()
          end
        end
      '';
    };
  };
}
