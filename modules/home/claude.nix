# Claude Code CLI — routed through an internal LiteLLM gateway whose endpoint
# and token both come from sops.
#
# Neither value is baked into settings.json: that file is generated into the
# world-readable Nix store (mode 444), so a `builtins.readFile` of either would
# publish it — the token obviously, and the gateway's hostname because it names
# internal infrastructure. Instead we decrypt both at shell start and export
# ANTHROPIC_BASE_URL and ANTHROPIC_AUTH_TOKEN from the values, so they exist
# only in the shell's environment. This also means the config evaluates/builds
# fine when the age key is not present.
{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.claude-code = {
    enable = true;
    settings = {
      env = {
        ANTHROPIC_DEFAULT_SONNET_MODEL = "claude-sonnet-5";
        ANTHROPIC_DEFAULT_HAIKU_MODEL = "claude-haiku-4-5";
        ANTHROPIC_DEFAULT_OPUS_MODEL = "claude-opus-5";
      };
      # effortLevel is a single global scalar — Claude Code has no per-model
      # effort mapping, and Haiku ignores effort entirely, so this only applies
      # to Sonnet and Opus. Override per session with /effort.
      effortLevel = "medium";
      model = "haiku";
      statusline.enable = true;

      # Registers herdr's Claude integration, which reports native session
      # references so herdr can restore sessions on relaunch. `herdr
      # integration install claude` normally writes this itself, but it cannot:
      # home-manager owns settings.json as a read-only store symlink. Shape and
      # timeout mirror herdr's own canonical hook value.
      hooks.SessionStart = [
        {
          matcher = "*";
          hooks = [
            {
              type = "command";
              command = "bash '${config.programs.claude-code.configDir}/hooks/herdr-agent-state.sh' session";
              timeout = 10;
            }
          ];
        }
      ];
    };

    # Herdr's own skill, which teaches Claude to drive the `herdr` CLI from
    # inside a pane (split panes, start/prompt other agents, read output).
    # nixpkgs' herdr package installs upstream's skills/ tree under
    # share/skills, so the skill tracks the installed binary instead of being
    # vendored here. The doubled path segment is upstream's own layout:
    # share/skills is the tree root and share/skills/herdr/herdr is the skill
    # directory holding SKILL.md, which is the level home-manager must link.
    skills.herdr = "${config.programs.herdr.package}/share/skills/herdr/herdr";

    # The integration's hook script, taken from the same herdr revision as the
    # binary so its version marker stays in step with what herdr expects. Do
    # not run `herdr integration install claude` on top of this.
    hooks."herdr-agent-state.sh" = "${pkgs.herdr.src}/src/integration/assets/claude/herdr-agent-state.sh";
  };

  # This used to read files that sops-nix staged on a RAM disk, but its darwin
  # backend is dead on macOS 27: `hdiutil attach -nomount ram://N` is deprecated
  # there, and although it still prints a device path it creates no device node,
  # so `newfs_hfs` fails and no secret is ever written. The failure was silent
  # because the old `[ -r <path> ]` guards simply skipped both exports. (The
  # replacement `diskutil image attach --noMount ram://N` fails too, so patching
  # sops-nix's mount strategy would not have helped.)
  #
  # Decrypting here instead keeps the plaintext off every filesystem rather than
  # on a RAM disk, and drops sops-nix from the config entirely. The ciphertext is
  # a path literal, so Nix copies it into the store — fine, it is encrypted.
  # `--extract` prints the bare value with no trailing newline. Two calls cost
  # ~40ms per shell start, well under the `fastfetch` already in zsh.nix.
  #
  # The `-n` guards matter: on a decrypt failure this exports nothing, rather
  # than an empty ANTHROPIC_BASE_URL that the CLI would try to reach.
  programs.zsh.initContent = lib.mkAfter ''
    if [ -r "$HOME/.config/sops/age/keys.txt" ]; then
      _claude_sops() {
        SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt" \
          ${pkgs.sops}/bin/sops -d --extract "[\"$1\"]" \
          ${../../secrets/claude.yaml} 2>/dev/null
      }
      _claude_url="$(_claude_sops claude_prod_url)"
      _claude_token="$(_claude_sops claude_prod_token)"
      [ -n "$_claude_url" ] && export ANTHROPIC_BASE_URL="$_claude_url"
      [ -n "$_claude_token" ] && export ANTHROPIC_AUTH_TOKEN="$_claude_token"
      unset _claude_url _claude_token
      unfunction _claude_sops
    fi
  '';
}
