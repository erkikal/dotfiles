# Pinned Catppuccin theme sources, shared across modules.
#
# This defines the module argument `catppuccin`, so any other home module can
# consume a pinned source by naming it in its arguments:
#
#   { catppuccin, ... }:
#   { ... = "${catppuccin.btop}/themes/catppuccin_mocha.theme"; }
#
# Keeping every (rev, hash) pin here means bumping a theme is a one-line change
# in a single file. Nix dedups downloads by (rev, hash), so referencing the
# same source from several modules fetches it once.
{ pkgs, ... }:

let
  fetch =
    repo: rev: hash:
    pkgs.fetchFromGitHub {
      owner = "catppuccin";
      inherit repo rev hash;
    };
in
{
  _module.args.catppuccin = {
    bat = fetch "bat" "6810349b28055dce54076712fc05fc68da4b8ec0"
      "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";

    btop = fetch "btop" "f437574b600f1c6d932627050b15ff5153b58fa3"
      "sha256-mEGZwScVPWGu+Vbtddc/sJ+mNdD2kKienGZVUcTSl+c=";

    yazi = fetch "yazi" "d62802be39210ea10e54b3e3b09735c6cb9e57c1"
      "sha256-bwzEO8exoBwa19q+jnYjHkaamGl2mhfukIEhDfUCRGI=";

    k9s = fetch "k9s" "fdbec82284744a1fc2eb3e2d24cb92ef87ffb8b4"
      "sha256-9h+jyEO4w0OnzeEKQXJbg9dvvWGZYQAO4MbgDn6QRzM=";

    starship = fetch "starship" "5906cc369dd8207e063c0e6e2d27bd0c0b567cb8"
      "sha256-FLHjbClpTqaK4n2qmepCPkb8rocaAo3qeV4Zp1hia0g=";
  };
}
