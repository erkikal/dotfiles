{
  description = "erkikal nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manger";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          pkgs.vim
        ];

      services.nix-daemon.enable = true;
      nix.settings.experimental-features = "nix-command flakes";
      programs.zsh.enable = true;  # default shell on catalina
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;
      nixpkgs.hostPlatform = "aarch64-darwin";
      security.pam.enableSudoTouchIdAuth = true;

      users.users.erkikal.home = "/Users/erkikal";
      home-manager.backupFileExtension = "backup";
      nix.configureBuildUser = true;
      nix.useDaemon = true;

      system.defaults = {
        dock.autohide = true;
        dock.mru-spaces = false;
        NSGlobalDomain._HIHideMenuBar = true;
        finder.AppleShowAllExtensions = treu;
        screencapture.location = "~/Pictures/Screenshots";
      };

      homebrew.enable = true;
      homebrew.casks = [

      ];
      homebrew.brews = [

      ];
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#G26WDDXVW7
    darwinConfigurations.hostname = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.erkikal = import ./home.nix;
          }
        ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations.hostname.pkgs;
  };
}
