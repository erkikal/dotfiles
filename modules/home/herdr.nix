# herdr terminal workspace manager.
{ ... }:

{
  programs.herdr = {
    enable = true;
    settings = {
      terminal = {
        default_shell = "zsh";
      };
    };
  };
}
