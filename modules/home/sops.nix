# sops-nix secret management.
#
# Requires an age key at ~/.config/sops/age/keys.txt on the machine. Encrypted
# files live under this repo's secrets/ and are referenced as flake-relative
# path literals, so Nix copies the ciphertext into the store at build time and
# sops decrypts it at activation using the age key. (A runtime path string like
# "${config.home.homeDirectory}/…" would instead read the file live from the
# working copy — breaking builds from a worktree or before the file exists.)
{ config, ... }:

{
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    # home-manager secrets are always owned by the user, so there is no `owner`
    # option here (unlike the system-level sops module).
    secrets.claude_demo_token = {
      sopsFile = ../../secrets/claude.yaml;
    };
  };
}
