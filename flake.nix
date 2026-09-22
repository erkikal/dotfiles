{
  description = "erkik nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    sops-nix.url = "github:Mic92/sops-nix";
    # Upstream pins nixos-26.05 to keep x86_64-darwin support, which this
    # aarch64-only host does not need; following nixpkgs builds sofka against
    # the same unstable set as everything else and avoids a second nixpkgs.
    sofka = {
      url = "github:nklmilojevic/sofka";
      inputs.nixpkgs.follows = "nixpkgs";
      # Only sofka's own `nix flake check` consumes this; following it keeps a
      # third home-manager out of the lock.
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, nixvim, nix-homebrew, sops-nix, sofka }:
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#erkik-mac-2
    darwinConfigurations."erkik-mac-2" = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./hosts/erkik-mac-2 ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."erkik-mac-2".pkgs;
  };
}
