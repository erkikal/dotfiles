# sops-nix secret management.
#
# Requires, on the machine:
#   * an age key at ~/.config/sops/age/keys.txt
#   * encrypted files under this repo's secrets/ directory
# Populate secrets/ before enabling anything that reads a secret (see claude.nix).
{ config, ... }:

let
  secrets = "${config.home.homeDirectory}/github/dotfiles/secrets";
in
{
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = "${secrets}/secrets.yaml";

    # home-manager secrets are always owned by the user, so there is no `owner`
    # option here (unlike the system-level sops module).
    secrets.claude_token = {
      sopsFile = "${secrets}/claude.yaml";
    };
  };
}
