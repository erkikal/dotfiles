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
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs;
        [ 
          bat
          btop
          carapace
          fastfetch
          gh
          # ghostty
          jankyborders
          k9s
          lazygit
          lazysql
          mkalias
          neovim
          nh
          nvd
          starship
          vim
          vivid
          #wezterm
          yazi
          zellij
          zoxide
        ];

      homebrew = {
        enable = true;
        casks = [
          "amethyst"
          # "arc"
          # "aws-vpn-client"
          # "chef-workstation"
          "font-terminess-ttf-nerd-font"
          "ghostty"
          "keepassxc"
          # "keymapp"
          "linearmouse"
          "logi-options+"
          "microsoft-edge"
          # "nikitabobko/tap/aerospace"
          "obsidian"
          # "orbstack"
          # "rancher"
          "raycast"
          # "tableplus"
          # "vagrant"
          # "vivaldi"
          # "zen-browser"
        ];
        brews = [
          "ansible"
          "ansible-lint"
          "libssh2"
          # "bat"
          # "btop"
          "direnv"
          "doggo"
          "duf"
          "dust"
          "eza"
          # "fastfetch"
          "fd"
          "harfbuzz"
          "libass"
          "tesseract"
          "ffmpegthumbnailer"
          "fzf"
          # "gh"
          "git"
          "git-fixup"
          "git-interactive-rebase-tool"
          # "glab"
          "glib-networking"
          "gstreamer"
          "helm"
          "jq"
          "kanata"
          "kubernetes-cli"
          "kubectx"
          # "lazygit"
          # "lazysql"
          "nmap"
          "node"
          "npm"
          # "pngpaste"
          "poetry"
          "poppler"
          "pure"
          "pwgen"
          "python@3.10"
          "python@3.11"
          "python@3.12"
          "python@3.13"
          "ripgrep"
          "sd"
          # "starship"
          "stern"
          "tldr"
          "unar"
          # "vault"
          "wget"
          "xh"
          # "yazi"
          # "zellij"
          # "zoxide"
          # "argoproj/tap/kubectl-argo-rollouts"
          # "azure/kubelogin/kubelogin"
          "danielfoehrkn/switch/switch"
          # "derailed/k9s/k9s"
          "felixkratz/formulae/borders"
          "felixkratz/formulae/sketchybar"
          "hashicorp/tap/terraform"
          "hashicorp/tap/terraform-ls"
          # "jeffreywildman/virt-manager/virt-viewer"
          # "robscott/tap/kube-capacity"
        ];
        taps = [
          # "argoproj/tap"
          # "azure/kubelogin"
          "danielfoehrkn/switch"
          # "derailed/k9s"
          "felixkratz/formulae"
          "hashicorp/tap"
          # "homebrew/bundle"
          # "jeffreywildman/virt-manager"
          # "robscott/tap"
        ];
        masApps = {

        };
        onActivation = {
          upgrade = true;
          autoUpdate = true;
          cleanup = "uninstall";
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
      # nix.configureBuildUser = true;
      # ids.uids.nixbld = 350;

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
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.erkik = import ./home.nix;
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
