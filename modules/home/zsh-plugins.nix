# The oh-my-zsh `git` and `kubectl` plugins, declared rather than vendored.
#
# These two used to live in this repo as hand-copies under zsh/, linked in via
# home.file and sourced by hand. That broke them: both plugins depend on
# oh-my-zsh's core lib/, which a standalone copy of a plugin file does not
# bring along, so `git_current_branch` — which git.plugin.zsh calls 15 times —
# was simply undefined and every alias built on it (ggpush, ggsup, groh, …)
# expanded to a command with an empty branch name.
#
# Sourcing the files out of pkgs.oh-my-zsh instead keeps them current with the
# nixpkgs bump, and supplying the handful of lib/ helpers they actually need
# (below) fixes the dependency without pulling in oh-my-zsh itself:
# programs.zsh.oh-my-zsh would source all 22 lib/*.zsh, and with them 67
# bindkeys, ~20 setopts (auto_cd, share_history, correct_all) and its own
# l/ll/la — none of which this config wants.
{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    plugins = [
      {
        name = "git";
        src = pkgs.oh-my-zsh;
        file = "share/oh-my-zsh/plugins/git/git.plugin.zsh";
      }
      {
        name = "kubectl";
        src = pkgs.oh-my-zsh;
        file = "share/oh-my-zsh/plugins/kubectl/kubectl.plugin.zsh";
      }
    ];

    # Order 550, so these exist before the plugins are sourced at 900.
    #
    # This is the complete set of lib/ helpers the two plugin files need:
    # `is-at-least` comes from zsh itself and `git_version` the git plugin sets
    # on its own, which leaves these three. git_current_branch is verbatim from
    # oh-my-zsh lib/git.zsh and is the only caller of __git_prompt_git; clipcopy
    # is reached only by `gbcopy`, and is lib/clipboard.zsh's darwin branch
    # inlined — its 12-platform detection is moot on an aarch64-darwin host.
    initContent = lib.mkOrder 550 ''
      __git_prompt_git() {
        GIT_OPTIONAL_LOCKS=0 command git "$@"
      }

      git_current_branch() {
        local ref
        ref=$(__git_prompt_git symbolic-ref --quiet HEAD 2> /dev/null)
        local ret=$?
        if [[ $ret != 0 ]]; then
          [[ $ret == 128 ]] && return  # no git repo.
          ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null) || return
        fi
        echo ''${ref#refs/heads/}
      }

      clipcopy() {
        cat "''${1:-/dev/stdin}" | pbcopy
      }

      # Not a cache worth reading: the kubectl plugin unconditionally writes a
      # generated completion to $ZSH_CACHE_DIR/completions/_kubectl, and with
      # the variable unset that redirect landed on /completions/_kubectl and
      # failed on every shell start — invisibly, since the plugin backgrounds
      # it. Nothing consumes the file either way, because carapace binds
      # kubectl completion at order 1000, after the plugin at 900. This just
      # gives the write a real directory so it stops failing.
      ZSH_CACHE_DIR="${config.xdg.cacheHome}/oh-my-zsh"
    '';
  };

  # The redirect above cannot create its own parent directory. home-manager's
  # own oh-my-zsh module seeds this the same way, for the same reason
  # (nix-community/home-manager#761).
  home.file."${config.xdg.cacheHome}/oh-my-zsh/completions/.keep".text = "";
}
