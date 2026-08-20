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
  };

  programs.zsh.initContent = lib.mkAfter ''
    if [ -r "${config.sops.secrets.claude_token.path}" ]; then
      export ANTHROPIC_AUTH_TOKEN="$(cat ${config.sops.secrets.claude_token.path})"
    fi
  '';
}
