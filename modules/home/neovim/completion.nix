# Completion (blink.cmp) and the Lua-development types that feed it.
{ ... }:

{
  # blink.cmp replaces nvim-cmp, LuaSnip, cmp_luasnip, cmp-nvim-lsp and
  # cmp-path. It carries its own snippet engine and LSP capabilities, so the
  # `make_client_capabilities` plumbing the old config did by hand is gone.
  plugins.blink-cmp = {
    enable = true;
    settings = {
      # The `default` preset, plus <Tab>/<S-Tab> to walk the menu. The preset's
      # own <C-n>/<C-p>/<C-y> are all kept; only the two Tab keys are added, and
      # both fall through when no menu is open so Tab still indents.
      #
      # <CR> is deliberately NOT bound to accept. It would swallow the newline
      # whenever the menu happened to be showing, which is most of the time while
      # typing — <C-y> stays the explicit accept.
      keymap = {
        preset = "default";
        "<Tab>" = [
          "select_next"
          "fallback"
        ];
        "<S-Tab>" = [
          "select_prev"
          "fallback"
        ];
      };
      appearance.nerd_font_variant = "normal";
      signature.enabled = true;
      # `documentation` lives under `completion`, not at the top level. Spelled
      # correctly here: blink validates its schema and warns about unexpected
      # top-level fields, so as `documentation.auto_show` it never took effect.
      completion.documentation.auto_show = true;
      # `snippets` is in the source list below, but nothing served it until now:
      # blink's built-in snippet source scans the runtimepath for
      # friendly-snippets and found no such entry. luasnip is the engine,
      # friendly-snippets the corpus, and this preset points blink at luasnip
      # rather than its own minimal built-in expander.
      snippets.preset = "luasnip";
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

  # The snippet engine and corpus behind `sources.default`'s `snippets` entry.
  # Enabling friendly-snippets is enough to register it: its nixvim module adds an
  # element to `plugins.luasnip.fromVscode`, which is what triggers the load.
  plugins.luasnip.enable = true;
  plugins.friendly-snippets.enable = true;

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
