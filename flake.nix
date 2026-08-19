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
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    erkikal-dotfiles.url = "github:erkikal/dotfiles";
    sops-nix.url = "github:Mic92/sops-nix";
    herdr.url = "github:herdrdev/herdr/v0.7.5";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-homebrew, erkikal-dotfiles, sops-nix, herdr }:
  let
    configuration = { pkgs, config, sops-nix, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs;
        [
          age
          bat
          btop
          carapace
          fastfetch
          jankyborders
          k9s
          lazysql
          mkalias
          neovim
          nh
          nvd
          sops
          starship
          vim
          vivid
          yazi
          zoxide
        ];

      homebrew = {
        enable = true;
        casks = [
          "amethyst"
          "betterdisplay"
          "font-terminess-ttf-nerd-font"
          "ghostty"
          "keepassxc"
          "linearmouse"
          "obsidian"
          "raycast"
        ];
        brews = [
          "ansible"
          "ansible-lint"
          "libssh2"
          "direnv"
          "doggo"
          "duf"
          "dust"
          "eza"
          "fd"
          "harfbuzz"
          "libass"
          "tesseract"
          "ffmpegthumbnailer"
          "fzf"
          "git-fixup"
          "git-interactive-rebase-tool"
          "glib-networking"
          "gstreamer"
          "helm"
          "jq"
          "kanata"
          "kubernetes-cli"
          "kubectx"
          "nmap"
          "node"
          "npm"
          "poetry"
          "poppler"
          "pure"
          "pwgen"
          "python@3.13"
          "python@3.14"
          "ripgrep"
          "sd"
          "stern"
          "task"
          "taskwarrior-tui"
          "tldr"
          "unar"
          "vault"
          "wget"
          "xh"
          "danielfoehrkn/switch/switch"
          "derailed/k9s/k9s"
          "felixkratz/formulae/borders"
          "felixkratz/formulae/sketchybar"
          "gtab"
          "hashicorp/tap/terraform"
          "hashicorp/tap/terraform-ls"
        ];
        taps = [
          {
            name = "danielfoehrkn/switch";
            trusted = true;
          }
          {
            name = "derailed/k9s";
            trusted = true;
          }
          {
            name = "felixkratz/formulae";
            trusted = true;
          }
          { 
            name = "Franvy/gtab";
            trusted = true;
          }
          {
            name = "hashicorp/tap";
            trusted = true;
          }
        ];
        masApps = {

        };
        onActivation = {
          upgrade = true;
          autoUpdate = true;
          cleanup = "zap";
          extraFlags = [
            "--force-cleanup"
          ];
        };
      };

      fonts.packages = [
        pkgs.nerd-fonts.terminess-ttf
      ];

      nixpkgs.config.allowUnfree = true;
      nix.settings.experimental-features = "nix-command flakes";
      programs.zsh = {
        enable = true;  # default shell on catalina
        enableSyntaxHighlighting = true;
      };
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
      nixpkgs.hostPlatform = "aarch64-darwin";
      security.pam.services.sudo_local.touchIdAuth = true;

      users.users.erkik.home = "/Users/erkik";
      home-manager.backupFileExtension = "backup";

      system.primaryUser = "erkik";
      system.defaults = {
        dock.autohide = true;
        dock.mru-spaces = false;
        NSGlobalDomain._HIHideMenuBar = true;
        finder.AppleShowAllExtensions = true;
        screencapture.location = "~/Pictures/Screenshots";
        # screencapture.target = "clipboard";
        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
        NSGlobalDomain.KeyRepeat = 2;
      };      
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#erkik-mac-2
    darwinConfigurations."erkik-mac-2" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        sops-nix.darwinModules.sops
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.erkik = import ./home.nix;
          home-manager.sharedModules = [
            inputs.sops-nix.homeManagerModules.sops
          ];
        }
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "erkik";

            autoMigrate = true;
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."erkik-mac-2".pkgs;
  };
}
