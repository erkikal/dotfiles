# atuin — shell history.
{ ... }:

{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      secrets_filter = true;
      enter_accept = true;
      pty_proxy.enabled = true;
    };
  };
}
