# Starship prompt (Catppuccin Mocha).
#
# The Mocha palette is sourced from upstream (see catppuccin.nix for the pin):
# themes/mocha.toml defines `[palettes.catppuccin_mocha]`, which we parse and
# merge into the settings below; `palette` selects it.
{ catppuccin, lib, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = lib.recursiveUpdate (builtins.fromTOML (
      builtins.readFile "${catppuccin.starship}/themes/mocha.toml"
    )) {
      # Use Catppuccin theme (Mocha variant)
      palette = "catppuccin_mocha";

      add_newline = false;

      format = "$os$username$hostname$kubernetes$directory$git_branch$git_status$line_break$character";

      right_format = "$python $terraform $aws $env_var $time";

      # Modern symbol styling
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
        vimcmd_symbol = "[](bold fg:color_green)";
        vimcmd_replace_one_symbol = "[](bold fg:color_purple)";
        vimcmd_replace_symbol = "[](bold fg:color_purple)";
        vimcmd_visual_symbol = "[](bold fg:color_yellow)";
      };

      os = {
        disabled = false;
        format = "[$symbol](bold white) ";
        symbols = {
          Windows = " ";
          Arch = "󰣇";
          Ubuntu = "";
          Macos = "󰀵";
          Debian = "";
          NixOS = "";
        };
      };

      username = {
        style_user = "white bold";
        style_root = "black bold";
        format = "[$user]($style)";
        disabled = false;
        show_always = true;
      };

      hostname = {
        ssh_only = true;
        format = "@[$hostname](bold yellow)";
        disabled = false;
      };

      kubernetes = {
        format = "[󱃾 $context($namespace)](bold purple) ";
        disabled = false;
      };

      aws = {
        format = "[$symbol($profile)($duration)]($style) ";
        disabled = false;
        style = "bold green";
      };

      # Disable some modules that might slow down the prompt
      gcloud.disabled = true;

      # Directory configuration
      directory = {
        truncation_length = 3;
        truncation_symbol = "…/";
        truncate_to_repo = false;
        home_symbol = "󰋜 ~";
        read_only_style = "197";
        read_only = "  ";
        format = " at [$path]($style)[$read_only]($read_only_style) ";
      };

      # Git configuration
      git_branch = {
        symbol = " ";
        # truncation_length = 20;
        format = "[$symbol$branch]($style)";
        truncation_symbol = "…/";
        style = "bold green";
      };

      git_status = {
        format = "[$all_status$ahead_behind]($style)";
        conflicted = "🏳";
        ahead = "⇡";
        diverged = "⇕⇡|⇣";
        behind = "⇣";
        up_to_date = "✓";
        untracked = " ";
        stashed = "📦";
        modified = "📝";
        staged = "[++\\($count\\)](green)";
        renamed = "👅";
        deleted = "🗑";
      };

      # Nix shell configuration
      nix_shell = {
        symbol = "❄️ ";
        format = "via [$symbol$state( \($name\))]($style) ";
      };

      # ZMX session identifier
      env_var.ZMX_SESSION = {
        symbol = " ";
        format = "[$symbol$env_value]($style) ";
        description = "zmx session name";
        style = "bold magenta";
      };
    };
  };
}
