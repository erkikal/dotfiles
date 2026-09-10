# Claude Code CLI — routed through the internal LiteLLM gateway.
#
# The auth token is NOT baked into settings.json: that file is generated into
# the world-readable Nix store (mode 444), so a `builtins.readFile` of the
# secret would leak it. Instead we export ANTHROPIC_AUTH_TOKEN at shell start
# from the sops-decrypted file (mode 0400, user-only). This also means the
# config evaluates/builds fine when the secret is not yet present.
{ config, lib, ... }:

{
  programs.claude-code = {
    enable = true;
    settings = {
      env = {
        ANTHROPIC_BASE_URL = "https://litellm.demo.riaint.ee";
        ANTHROPIC_DEFAULT_SONNET_MODEL = "claude-sonnet-4-6";
        ANTHROPIC_DEFAULT_HAIKU_MODEL = "claude-haiku-4-5";
        ANTHROPIC_DEFAULT_OPUS_MODEL = "claude-opus-4-8";
      };
      effortLevel = "medium";
      model = "haiku";
      statusline.enable = true;
    };

    # Herdr's own skill, which teaches Claude to drive the `herdr` CLI from
    # inside a pane (split panes, start/prompt other agents, read output).
    # nixpkgs' herdr package installs upstream's SKILL.md into
    # share/herdr/skills/herdr, so the skill tracks the installed binary
    # instead of being vendored here.
    skills.herdr = "${config.programs.herdr.package}/share/herdr/skills/herdr";
  };

  programs.zsh.initContent = lib.mkAfter ''
    if [ -r "${config.sops.secrets.claude_demo_token.path}" ]; then
      export ANTHROPIC_AUTH_TOKEN="$(cat ${config.sops.secrets.claude_demo_token.path})"
    fi
  '';
}
