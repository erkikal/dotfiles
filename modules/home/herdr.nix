# herdr terminal workspace manager.
{ ... }:

{
  programs.herdr = {
    enable = true;
    settings = {
      # A missing `onboarding` key makes herdr show the first-run notification
      # setup on every launch, so it has to be written out explicitly.
      onboarding = false;

      terminal = {
        default_shell = "zsh";
      };
    };
  };
}
