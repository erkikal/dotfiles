{
  description = "erkikal nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
          pkgs.carapace
          pkgs.mkalias
          pkgs.neovim
          pkgs.vim
          pkgs.vivid
          pkgs.wezterm
        ];

      homebrew = {
        enable = true;
        casks = [
          "amethyst"
          # "arc"
          "aws-vpn-client"
          "chef-workstation"
          "font-terminess-ttf-nerd-font"
          "ghostty"
          "keepassxc"
          "keymapp"
          "linearmouse"
          "logitech-g-hub"
          # "logitech-options"
          # "nikitabobko/tap/aerospace"
          "obsidian"
          "orbstack"
          "raycast"
          # "tableplus"
          "vagrant"
          "vivaldi"
          "zen-browser"
        ];
        brews = [
          "ansible"
          "ansible-lint"
          "libssh2"
          "bat"
          "btop"
          "direnv"
          "duf"
          "dust"
          "eza"
          "fastfetch"
          "fd"
          "harfbuzz"
          "libass"
          "tesseract"
          "ffmpegthumbnailer"
          "fzf"
          "gh"
          "git"
          "git-fixup"
          "git-interactive-rebase-tool"
          "glab"
          "glib-networking"
          "gstreamer"
          "helm"
          "jq"
          "kanata"
          "kubernetes-cli"
          "kubectx"
          "lazygit"
          "nmap"
          "pngpaste"
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
          "starship"
          "stern"
          "tldr"
          "unar"
          "wget"
          "xh"
          "yazi"
          "zellij"
          "zoxide"
          "argoproj/tap/kubectl-argo-rollouts"
          "azure/kubelogin/kubelogin"
          "danielfoehrkn/switch/switch"
          "derailed/k9s/k9s"
          "felixkratz/formulae/borders"
          "felixkratz/formulae/sketchybar"
          "hashicorp/tap/terraform"
          "jeffreywildman/virt-manager/virt-viewer"
          "robscott/tap/kube-capacity"
        ];
        taps = [
          "argoproj/tap"
          "azure/kubelogin"
          "danielfoehrkn/switch"
          "derailed/k9s"
          "felixkratz/formulae"
          "hashicorp/tap"
          "homebrew/bundle"
          "homebrew/cask-fonts"
          "homebrew/services"
          "jeffreywildman/virt-manager"
          "robscott/tap"
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
      system.stateVersion = 4;
      nixpkgs.hostPlatform = "aarch64-darwin";
      security.pam.services.sudo_local.touchIdAuth = true;

      users.users.erkikal.home = "/Users/erkikal";
      home-manager.backupFileExtension = "backup";
      # nix.configureBuildUser = true;
      ids.uids.nixbld = 300;

      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
          # Set up applications.
          echo "setting up /Applications..." >&2
          rm -rf /Applications/Nix\ Apps
          mkdir -p /Applications/Nix\ Apps
          find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read -r src; do
            app_name=$(basename "$src")
            echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done
        '';

      system.defaults = {
        dock.autohide = true;
        dock.mru-spaces = false;
        NSGlobalDomain._HIHideMenuBar = true;
        finder.AppleShowAllExtensions = true;
        screencapture.location = "~/Pictures/Screenshots";
        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
        NSGlobalDomain.KeyRepeat = 2;
      };      
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#G26WDDXVW7
    darwinConfigurations."G26WDDXVW7" = nix-darwin.lib.darwinSystem {
      modules = [ 
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.erkikal = import ./home.nix;
          }
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "erkikal";

              autoMigrate = true;
            };
          }
        ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."G26WDDXVW7".pkgs;
  };
}
