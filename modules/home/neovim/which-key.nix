# which-key: the leader-key popup and the group labels it shows.
{ ... }:

{
  # The old config carried upstream kickstart's long non-nerd-font `icons.keys`
  # fallback table. `have_nerd_font` is true here, so that branch was dead code;
  # only the nerd-font side is ported.
  plugins.which-key = {
    enable = true;
    settings = {
      preset = "helix";
      icons.mappings = true;
      spec = [
        {
          __unkeyed-1 = "<leader>c";
          group = "[C]ode";
          mode = [
            "n"
            "x"
          ];
        }
        {
          __unkeyed-1 = "<leader>d";
          group = "[D]ocument";
        }
        {
          __unkeyed-1 = "<leader>r";
          group = "[R]ename";
        }
        {
          __unkeyed-1 = "<leader>s";
          group = "[S]earch";
        }
        {
          __unkeyed-1 = "<leader>w";
          group = "[W]orkspace";
        }
        {
          __unkeyed-1 = "<leader>t";
          group = "[T]oggle";
        }
        {
          __unkeyed-1 = "<leader>h";
          group = "Git [H]unk";
          mode = [
            "n"
            "v"
          ];
        }
        # Groups for the keymaps this config adds beyond kickstart's set.
        {
          __unkeyed-1 = "<leader>f";
          group = "[F]ind";
        }
        {
          __unkeyed-1 = "<leader>m";
          group = "[M]arkdown / notes";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "[G]it / tools";
        }
        {
          __unkeyed-1 = "<leader>n";
          group = "[N]otifications";
        }
      ];
    };
  };
}
