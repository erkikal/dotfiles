# Ghostty terminal — config managed by home-manager.
#
# ghostty is not packaged for darwin in nixpkgs (Linux-only), so the binary
# comes from the Homebrew cask (see modules/darwin/homebrew.nix) and we set
# package = null. home-manager only renders $XDG_CONFIG_HOME/ghostty/config.
# Settings mirror the former ./ghostty/config, which is now superseded by this.
{ ... }:

{
  programs.ghostty = {
    enable = true;
    package = null;
    enableZshIntegration = true;

    settings = {
      macos-auto-secure-input = true;

      shell-integration = "zsh";
      shell-integration-features = "sudo,ssh-terminfo,ssh-env";
      notify-on-command-finish = "unfocused";

      clipboard-read = "allow";
      clipboard-write = "allow";
      copy-on-select = true;

      theme = "Catppuccin Mocha";
      background = "#1E1E2E";
      foreground = "#CDD6F4";
      selection-background = "#585B70";
      selection-foreground = "#CDD6F4";
      split-divider-color = "#9CDF97";
      macos-titlebar-style = "transparent";

      font-family = "Terminess Nerd Font";
      font-size = 14;

      macos-option-as-alt = true;
      keybind = [
        "global:cmd+s=toggle_quick_terminal"
        "alt+left=goto_split:left"
        "alt+down=goto_split:down"
        "alt+up=goto_split:up"
        "alt+right=goto_split:right"
        "alt+h=goto_split:previous"
        "alt+j=goto_split:down"
        "alt+k=goto_split:up"
        "alt+l=goto_split:next"
        "alt+two=text:@"
        "alt+three=text:£"
        "alt+four=text:$"
        "alt+seven=text:{"
        "alt+eight=text:["
        "alt+nine=text:]"
        "alt+zero=text:}"
        "alt+ä=text:^"
        "alt+plus=text:\\\\"
        "alt+<=text:|"
      ];

      quick-terminal-animation-duration = 0;
    };
  };
}
