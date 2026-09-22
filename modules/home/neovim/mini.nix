# mini.nvim, the modules of it that are in use.
{ ... }:

{
  # `use_icons = vim.g.have_nerd_font` is written out as `true`: the global is
  # set in this same config, so there is nothing to read it from.
  plugins.mini = {
    enable = true;
    modules = {
      ai.n_lines = 500;
      surround = { };
      statusline.use_icons = true;
      comment = { };
      jump = { };
      pairs = { };
      move.mappings = {
        left = "H";
        right = "L";
        down = "J";
        up = "K";
      };
      operators = { };
    };
  };

  # `section_location` is overridden after setup, as before — it is a field on
  # the module, not a setup option.
  extraConfigLua = ''
    require('mini.statusline').section_location = function()
      return '%2l:%-2v'
    end
  '';
}
