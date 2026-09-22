# Markdown and note-taking: rendering (markview), preview, and the Obsidian
# vault.
{ pkgs, ... }:

{
  # `hybrid_modes` was top-level in the old lazy.nvim spec, so lazy never passed
  # it to `setup()` and hybrid mode never actually turned on. In current markview
  # it also moved under `preview`.
  plugins.markview = {
    enable = true;
    settings.preview.hybrid_modes = [ "n" ];
  };

  plugins.markdown-preview.enable = true;

  # obsidian.nvim: `epwalsh/obsidian.nvim` is dormant; this is the community fork
  # `obsidian-nvim/obsidian.nvim` (nixpkgs' `obsidian-nvim`), currently 3.x.
  # Several options from the old config are renamed or gone there:
  #
  #   templates.subdir      -> templates.folder
  #   templates.tags        -> removed outright (it was empty anyway)
  #   completion.nvim_cmp   -> removed. Completion now comes from the plugin's
  #                            own in-process LSP server, so it arrives through
  #                            blink's existing `lsp` source with nothing to
  #                            declare here.
  #   tag_mappings.*        -> picker.tag_mappings.*
  #   mappings              -> removed outright; keymaps are the user's to set,
  #                            so <leader>mf / <leader>md are plain keymaps below.
  #   legacy_commands       -> defaults to true and warns; turned off.
  #
  # Date formats changed dialect too: the fork parses moment.js tokens unless the
  # string contains a `%`, in which case it falls back to `os.date`. The existing
  # strftime formats therefore still work and are kept verbatim rather than
  # translated.
  plugins.obsidian = {
    enable = true;
    settings = {
      legacy_commands = false;

      workspaces = [
        {
          name = "Work";
          path = "~/Documents/Notes";
        }
      ];

      daily_notes = {
        folder = "dailies";
        date_format = "%Y-%m-%d-%a";
        alias_format = "%B %-d, %Y";
        default_tags = [ "daily-notes" ];
      };

      completion.min_chars = 2;

      templates = {
        folder = "Templates";
        date_format = "%Y-%m-%d-%a";
        time_format = "%H:%M";
      };

      picker = {
        name = "telescope.nvim";
        tag_mappings = {
          tag_note = "<C-x>";
          insert_tag = "<C-l>";
        };
      };

      note_id_func.__raw = ''
        function(title)
          -- Zettelkasten-style IDs: a timestamp plus a slug of the title, so
          -- 'My new note' becomes '1657296016-my-new-note.md'.
          local suffix = ""
          if title ~= nil then
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          else
            -- No title: four random uppercase letters.
            for _ = 1, 4 do
              suffix = suffix .. string.char(math.random(65, 90))
            end
          end
          return tostring(os.time()) .. "-" .. suffix
        end
      '';
    };
  };

  # markdown-todo.nvim: checkbox state cycling for markdown task lists. Not in
  # nixpkgs, so it is built here and pinned by commit — the same revision the
  # lazy.nvim checkout was running, since upstream has had no commits since
  # mid-2024.
  #
  # `setup()` only registers autocmds that gate on `*.md`, so its <leader>t*
  # keymaps are buffer-local to markdown. That is why `<leader>th` here does not
  # actually collide with the LSP inlay-hint toggle, which is bound on attach in
  # code buffers.
  #
  # The old lazy spec had `ft = { "md", "markdown" }`; `md` is not a filetype, so
  # only the `markdown` half ever did anything. Nothing is lazy-loaded here, and
  # the plugin gates itself, so the key is dropped rather than corrected.
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "markdown-todo.nvim";
      version = "0-unstable-2024-06-15";
      src = pkgs.fetchFromGitHub {
        owner = "thenbe";
        repo = "markdown-todo.nvim";
        rev = "d29fa4fa648daf5db5aade75cb350064788e63a1";
        hash = "sha256-Fn++dtmBnteXzakRkbOU2IFagh/5wIdeYFIhlfwGtds=";
      };
    })
  ];

  # markdown-todo has no nixvim module, so it is set up by hand. The old spec
  # used lazy.nvim's `config = true`, which is the same bare setup() call.
  extraConfigLua = ''
    require('markdown-todo').setup()
  '';
}
