# Completion (blink.cmp) and the Lua-development types that feed it.
{ ... }:

{
  # blink.cmp replaces nvim-cmp, LuaSnip, cmp_luasnip, cmp-nvim-lsp and
  # cmp-path. It carries its own snippet engine and LSP capabilities, so the
  # `make_client_capabilities` plumbing the old config did by hand is gone.
  plugins.blink-cmp = {
    enable = true;
    settings = {
      keymap.preset = "default";
      appearance.nerd_font_variant = "normal";
      signature.enabled = true;
      # `documentation` lives under `completion`, not at the top level. Spelled
      # correctly here: blink validates its schema and warns about unexpected
      # top-level fields, so as `documentation.auto_show` it never took effect.
      completion.documentation.auto_show = true;
      sources = {
        default = [
          "lsp"
          "path"
          "snippets"
          "buffer"
          "lazydev"
        ];
        # obsidian.nvim 3.x serves completion from an in-process LSP server
        # (`obsidian-ls`) rather than registering a blink source. It checks that
        # blink advertises `lsp` for markdown and prints a migration notice if
        # not, so the markdown list is spelled out explicitly.
        per_filetype.markdown = [
          "lsp"
          "path"
          "snippets"
          "buffer"
        ];
        providers.lazydev = {
          name = "LazyDev";
          module = "lazydev.integrations.blink";
          # lazydev knows the Neovim API better than the generic LSP source
          # does for config files, so it outranks it.
          score_offset = 100;
        };
      };
    };
  };

  # Types and completion for the Neovim API when editing Lua config.
  plugins.lazydev = {
    enable = true;
    settings.library = [
      {
        path = "\${3rd}/luv/library";
        words = [ "vim%.uv" ];
      }
    ];
  };
}
