# Host: erkik-mac-2
# Composition root — wires the darwin modules, home-manager, nix-homebrew and
# sops, and sets host-specific identity (platform, primary user, state version).
{ inputs, ... }:

{
  imports = [
    ../../modules/darwin
    inputs.sops-nix.darwinModules.sops
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.primaryUser = "erkik";
  system.stateVersion = 6;
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  users.users.erkik.home = "/Users/erkik";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
    users.erkik = import ../../modules/home;
    sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
      inputs.sofka.homeManagerModules.sofka
    ];
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "erkik";
    autoMigrate = true;
  };
}
