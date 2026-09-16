# zoxide — smarter cd / directory jumping.
{ ... }:

{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd"
    ];
  };
}
