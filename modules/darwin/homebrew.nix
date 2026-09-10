# Declarative Homebrew management (via nix-homebrew).
{ ... }:

{
  homebrew = {
    enable = true;
    casks = [
      "amethyst"
      "betterdisplay"
      "font-terminess-ttf-nerd-font"
      "ghostty"
      "keepassxc"
      "linearmouse"
      "microsoft-edge"
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
}
