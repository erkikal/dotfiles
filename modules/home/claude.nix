# Claude Code CLI — routed through the internal LiteLLM gateway.
#
# The auth token is NOT baked into settings.json: that file is generated into
# the world-readable Nix store (mode 444), so a `builtins.readFile` of the
# secret would leak it. Instead we export ANTHROPIC_AUTH_TOKEN at shell start
# from the sops-decrypted file (mode 0400, user-only). This also means the
# config evaluates/builds fine when the secret is not yet present.
{ config, lib, pkgs, ... }:

{
  programs.claude-code = {
    enable = true;
    settings = {
      env = {
        ANTHROPIC_BASE_URL = "https://litellm.demo.riaint.ee";
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
    # nixpkgs' herdr package installs upstream's SKILL.md into
    # share/herdr/skills/herdr, so the skill tracks the installed binary
    # instead of being vendored here.
    skills.herdr = "${config.programs.herdr.package}/share/herdr/skills/herdr";

    # The integration's hook script, taken from the same herdr revision as the
    # binary so its version marker stays in step with what herdr expects. Do
    # not run `herdr integration install claude` on top of this.
    hooks."herdr-agent-state.sh" =
      "${pkgs.herdr.src}/src/integration/assets/claude/herdr-agent-state.sh";
  };

  programs.zsh.initContent = lib.mkAfter ''
    if [ -r "${config.sops.secrets.claude_demo_token.path}" ]; then
      export ANTHROPIC_AUTH_TOKEN="$(cat ${config.sops.secrets.claude_demo_token.path})"
    fi
  '';
}
