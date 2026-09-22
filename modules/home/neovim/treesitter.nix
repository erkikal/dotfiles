# Treesitter.
{ ... }:

{
  # nixvim's module targets the **main** branch. `ensure_installed` and
  # `auto_install` have no analogue there and are dropped: grammars come from
  # Nix (`grammarPackages`, which defaults to all of them), so nothing compiles
  # at runtime and there is no parser left to be missing.
  #
  # The old config's `additional_vim_regex_highlighting = { 'ruby' }` and
  # `indent.disable = { 'ruby' }` go too — both were carried in unchanged from
  # upstream kickstart and no ruby is edited here.
  plugins.treesitter = {
    enable = true;
    highlight.enable = true;
    indent.enable = true;
  };
}
