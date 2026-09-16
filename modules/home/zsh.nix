# Zsh: options, init, aliases and custom functions.
{ ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    # historySubstringSearch.enable = true;
    history = {
      size = 10000;
    };

    initContent = ''
      if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
        . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
      fi

      [[ -f $(brew --prefix switch)/switch.sh ]]; INSTALLATION_PATH=$(brew --prefix switch) && source $INSTALLATION_PATH/switch.sh

      fastfetch -c examples/8

      source ~/.zsh/git/git.plugin.zsh
      source ~/.zsh/kubectl/kubectl.plugin.zsh

      # keybinding
      bindkey "^[[1;5D" backward-word
      bindkey "^[[1;5C" forward-word
      # bindkey "^[[A" history-search-backward
      # bindkey "^[[B" history-search-forward
      bindkey "^A" beginning-of-line
      bindkey "^E" end-of-line
      bindkey "^[[3~" delete-char
      bindkey "^W" backward-kill-word
      bindkey " " magic-space

      # Set suffix aliases
      alias -s -- txt=nvim
      alias -s -- nix=nvim
      alias -s -- yml=nvim
      alias -s -- yaml=nvim
    '';

    shellAliases = {
      reload = "source ~/.zshrc";
      hist = "history 1 | less";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";
      ybssh = "ssh-add -s /usr/local/lib/opensc-pkcs11.so";


      # Indent clipboard with space, so if pasted to shell (bash/zsh), it doesn't get saved in history file
      repaste = "pbpaste | sed -e \"s/^/ /\" | pbcopy";

      # Nix commands
      nos = "nh darwin switch --dry";
      nosa = "nh darwin switch";
      ndiff = "nvd diff /run/current-system/nix/var/nix/profiles/system";

      ngc = "nh clean all --keep-since 7d --keep 10";
      ngcd = "nh clean all --dry --keep-since 7d --keep 10";

      l = "eza -lafF --color=auto --icons=auto";
      ll = "eza -laF --group-directories-first --color=auto";
      lt = "eza --tree --level=2 --long --icons --git";

      v = "nvim";
      vim = "nvim";
      sv = "sudo nvim";

      cat = "bat";

      cls = "clear && fastfetch -c examples/8";

      # confirm before overwriting something
      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";

      # easier to read disk
      df = "df -h";     # human-readable sizes
      free = "free -m"; # show sizes in MB

      # Improve common commands
      mkdir = "mkdir -p";

      # BetterDisplay input switching
      # -n --namelike
      # 15 - DP1 - PC
      # 16 - DP2
      # 17 - HDMI1
      # 18 - HDMI2 - Mac
      pcdp = "betterdisplaycli set -n=\"mi monitor\" -vcp=inputSelect -ddc=15";
      # Can not take over if other source is active
      # macdp = "betterdisplaycli set -n=\"mi monitor\" -vcp=inputSelect -ddc=18";
    };

    shellGlobalAliases = {
      NE = "2>/dev/null";
      NO = ">/dev/null";
      NUL = ">/dev/null 2>&1";

      C = "| pbcopy";
    };

    siteFunctions = {
      # mkdir and cd into it
      "mkcd" = ''
        mkdir -p -- "$1" && cd -P -- "$1"
      '';

      # Set AWS_PROFILE environment variable
      "aws-profile" = ''
        aws-profile() {
          compdef _aws_profile aws-profile

          if [ -f $HOME/.aws/config ]; then
            if [ -z "$1" ]; then
              if [ -z "$AWS_PROFILE" ]; then
                echo "No AWS profile is currently selected."
              else
                echo "Currently selected AWS profile is $AWS_PROFILE"
              fi
            else
              local profiles=$(aws configure list-profiles)
              local profile=$(echo "$profiles" | grep -w "$1")
              if [[ -n $profile ]]; then
                echo "Setting AWS_PROFILE to $1"
                export AWS_PROFILE=$1
              else
                echo "Profile $1 not found in $HOME/.aws/config"
              fi
            fi
          else
            echo "404: $HOME/.aws/config not found."
          fi
        }
      '';

      "_aws_profiles" = ''
        _aws_profiles() {
          if [ -f $HOME/.aws/config ]; then
            local -a profiles
            profiles=($(aws configure list-profiles))
            _describe 'aws profiles' profiles
          fi
        }
      '';

      # Define completion for aws-profile
      "_aws_profile" = ''
        _aws_profile() {
          _arguments '1: :_aws_profiles'
        }
      '';
    };
  };
}
