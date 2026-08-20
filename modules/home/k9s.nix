# k9s — Kubernetes TUI.
#
# Catppuccin skins are sourced from upstream (see catppuccin.nix for the pin)
# instead of being vendored in this repo. Every dist/*.yaml is linked to
# $XDG_CONFIG_HOME/k9s/skins/<name>.yaml via the module's `skins` option; the
# active one is selected by settings.k9s.ui.skin below.
{ catppuccin, lib, ... }:

{
  programs.k9s = {
    enable = true;
    settings = {
      k9s = {
        ui = {
          skin = "catppuccin-mocha-transparent";
        };
      };
    };
    aliases = {
      dp = "deployments";
      sec = "v1/secrets";
      jo = "jobs";
      cr = "clusterroles";
      crb = "clusterrolebindings";
      ro = "roles";
      rb = "rolebindings";
      np = "networkpolicies";
    };
    skins = lib.mapAttrs' (
      file: _:
      lib.nameValuePair (lib.removeSuffix ".yaml" file) "${catppuccin.k9s}/dist/${file}"
    ) (builtins.readDir "${catppuccin.k9s}/dist");
  };
}
