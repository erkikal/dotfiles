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
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    sops-nix.url = "github:Mic92/sops-nix";
    herdr.url = "github:herdrdev/herdr/v0.7.5";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, nix-homebrew, sops-nix, herdr }:
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
