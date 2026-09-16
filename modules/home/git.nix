# Git: dual (personal/work) identity, SSH signing, gh and lazygit.
{ config, pkgs, ... }:
let
  gitIdentity = pkgs.writeShellScriptBin "git-identity" (builtins.readFile ./git-identity);
in {
  home.packages = with pkgs; [
    gh
    git
    gitIdentity
    lazygit
  ];

  home.activation.createAllowedSigners = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    if [[ -f "${config.home.homeDirectory}/.ssh/erki.personal.pub" && -f "${config.home.homeDirectory}/.ssh/publickey.pub" ]]; then
      $DRY_RUN_CMD rm -f ${config.home.homeDirectory}/.ssh/allowed_signers
      $DRY_RUN_CMD echo "* $(cat ${config.home.homeDirectory}/.ssh/erki.personal.pub)" > ${config.home.homeDirectory}/.ssh/allowed_signers
      $DRY_RUN_CMD echo "* $(cat ${config.home.homeDirectory}/.ssh/publickey.pub)" >> ${config.home.homeDirectory}/.ssh/allowed_signers
    elif [[ -f "${config.home.homeDirectory}/.ssh/erki.personal.pub" ]]; then
      $DRY_RUN_CMD rm -f ${config.home.homeDirectory}/.ssh/allowed_signers
      $DRY_RUN_CMD echo "* $(cat ${config.home.homeDirectory}/.ssh/erki.personal.pub)" > ${config.home.homeDirectory}/.ssh/allowed_signers
    elif [[ -f "${config.home.homeDirectory}/.ssh/publickey.pub" ]]; then
      $DRY_RUN_CMD rm -f ${config.home.homeDirectory}/.ssh/allowed_signers
      $DRY_RUN_CMD echo "* $(cat ${config.home.homeDirectory}/.ssh/publickey.pub)" > ${config.home.homeDirectory}/.ssh/allowed_signers
    fi
  '';

  programs = {
    gh.enable = true;

    git = {
      enable = true;
      settings = {
        user = {
          useConfigOnly = true;

          personal.name = "Erki Kaljapulk";
          personal.email = "109873035+erkikal@users.noreply.github.com";
          personal.signingkey = "~/.ssh/erki.personal.pub";

          work.name = "Erki Kaljapulk";
          work.email = "12-erkik@users.noreply.gitlab.ria.ee";
          work.signingkey = "~/.ssh/publickey.pub";
        };
        aliases = {
          identity = "! git-identity";
          id = "! git-identity";
        };
        # commit.gpgsign = true;
        gpg = {
          ssh.allowedSignersFile = "~/.ssh/allowed_signers";
        };

      };
      signing = {
        format = "ssh";
        signByDefault = true;
      };
    };

    lazygit = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "lg";
    };
  };
}
