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
          pkgs.obsidian
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
          "keepassxc"
          "linearmouse"
          "logitech-g-hub"
          "logitech-options"
          "tableplus"
          "vagrant"
          "zen-browser"
        ];
        brews = [
          "ansible"
          "ansible-lint"
          "libssh2"
          "bat"
          "btop"
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
          "ripgrep"
          "sd"
          "starship"
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
        ];
        masApps = {

        };
        onActivation.upgrade = true;
        onActivation.autoUpdate = true;
      };

      fonts.packages = [
        (pkgs.nerdfonts.override { fonts = [ "Terminus" ]; })
      ];

      services.nix-daemon.enable = true;
      nixpkgs.config.allowUnfree = true;
      nix.settings.experimental-features = "nix-command flakes";
      programs.zsh = {
        enable = true;  # default shell on catalina
        enableSyntaxHighlighting = true;
      };
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;
      nixpkgs.hostPlatform = "aarch64-darwin";
      security.pam.enableSudoTouchIdAuth = true;
      # services.kanata = {
      #   enable = true;
      #   keyboards = {
      #     internalKeyboard = {
      #       devices = [
      #         "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
      #         "/dev/input/by-id/usb-Framework_Laptop_16_Keyboard_Module_-_ANSI_FRAKDKEN0100000000-event-kbd"
      #         "/dev/input/by-id/usb-Framework_Laptop_16_Keyboard_Module_-_ANSI_FRAKDKEN0100000000-if02-event-kbd"
      #       ];
      #       extraDefCfg = "process-unmapped-keys yes";
      #       config = ''
      #         (defsrc
      #          a s d f j k l ö
      #         )
      #         (defvar
      #          tap-time 150
      #          hold-time 200
      #         )
      #         (defalias
      #          a (tap-hold $tap-time $hold-time a lmet)
      #          s (tap-hold $tap-time $hold-time s lalt)
      #          d (tap-hold $tap-time $hold-time d lsft)
      #          f (tap-hold $tap-time $hold-time f lctl)
      #          j (tap-hold $tap-time $hold-time j rctl)
      #          k (tap-hold $tap-time $hold-time k rsft)
      #          l (tap-hold $tap-time $hold-time l ralt)
      #          ö (tap-hold $tap-time $hold-time ö rmet)
      #         )
      #
      #         (deflayer base
      #          @a  @s  @d  @f  @j  @k  @l  @ö
      #         )
      #       '';
      #     };
      #   };
      # };

      users.users.erkikal.home = "/Users/erkikal";
      home-manager.backupFileExtension = "backup";
      # nix.configureBuildUser = true;
      nix.useDaemon = true;

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
          while read src; do
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
