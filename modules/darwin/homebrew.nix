# Declarative Homebrew management (via nix-homebrew).
{...}: {
  homebrew = {
    enable = true;
    casks = [
      "amethyst"
      "betterdisplay"
      "font-terminess-ttf-nerd-font"
      "ghostty"
      "keepassxc"
      "linearmouse"

      # Install-only, deliberately: Raycast has no configuration surface Nix can
      # own. home-manager has no programs.raycast, and the app's own state is an
      # encrypted SQLite store it holds open read-write for its whole runtime, so
      # a read-only store symlink would break WAL checkpointing outright. What is
      # left — ~/Library/Preferences/com.raycast.macos.plist — it rewrites while
      # running, and of its 76 keys most are migration flags, opaque blobs or
      # machine-specific caches (window position keyed by monitor geometry), so
      # even the four stable ones (global hotkey, window mode, follow-appearance,
      # hyper-key icon) would race the app rather than configure it. Hotkeys and
      # extensions are set in the app, not here.
      #
      # The repo used to link a raycast/ directory for this; it was an extension
      # cache that Raycast has since stopped reading — extensions moved into
      # raycast-enc.sqlite — so it was deleted, not merely unlinked.
      #
      # Raycast self-updates, so the running app drifts ahead of the cask version.
      # That is the app's design, not drift to correct.
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
      "felixkratz/formulae/borders"
      "felixkratz/formulae/sketchybar"
      "hashicorp/tap/terraform"
      "hashicorp/tap/terraform-ls"
    ];
    taps = [
      {
        name = "danielfoehrkn/switch";
        trusted = true;
      }
      {
        name = "felixkratz/formulae";
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
    };
  };
}
