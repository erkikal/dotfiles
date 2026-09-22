# snacks.nvim.
{ ... }:

{
  # Two keys in the old opts were typos and therefore inert: `intent` (for
  # `indent`) and `statuscolum` (for `statuscolumn`). Spelled correctly here —
  # and nixvim would have failed evaluation on the misspellings rather than
  # silently ignoring them.
  plugins.snacks = {
    enable = true;
    settings = {
      bigfile.enabled = true;
      dashboard = {
        enabled = true;
        # snacks' default sections are header, keys and startup. `startup` reports
        # startuptime via `require("lazy.stats")`, a lazy.nvim module that does not
        # exist here, so it throws on every UIEnter. The other two are respelled
        # as upstream has them, minus that section.
        sections = [
          { section = "header"; }
          {
            section = "keys";
            gap = 1;
            padding = 1;
          }
        ];
      };
      notifier = {
        enabled = true;
        timeout = 2000;
      };
      git.enabled = true;
      lazygit.enabled = true;
      indent.enabled = true;
      input.enabled = true;
      quickfile.enabled = true;
      statuscolumn.enabled = true;
      words.enabled = true;
      styles.notification.wo.wrap = true;
    };
  };

  # The `_G.dd`/`_G.bt` debug helpers came from a `User VeryLazy` autocmd in the
  # old snacks spec; there is no VeryLazy event without lazy.nvim and nothing
  # else needed to wait, so they are set directly. That spec also assigned a
  # global `Snacks`, which snacks exports itself.
  extraConfigLua = ''
    _G.dd = function(...)
      require('snacks').debug.inspect(...)
    end
    _G.bt = function()
      require('snacks').debug.backtrace()
    end
    vim.print = _G.dd
  '';
}
