{ inputs, pkgs, ... }:

let
  claudePackage = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;

  claudeSettings = {
    "$schema" = "https://json.schemastore.org/claude-code-settings.json";
    language = "vietnamese";
    includeGitInstructions = true;
    cleanupPeriodDays = 30;
    prefersReducedMotion = true;
    permissions = {
      defaultMode = "acceptEdits";
      deny = [
        "Read(./.env)"
        "Read(./.env.*)"
        "Read(./secrets/**)"
        "Read(./*.pem)"
        "Read(./*.key)"
      ];
    };
    env = {
      DISABLE_AUTOUPDATER = "1";
      USE_BUILTIN_RIPGREP = "0";
      CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
      API_TIMEOUT_MS = "1200000";
      ANTHROPIC_BASE_URL = "https://aihubapi.khoapi.dev/";
      ANTHROPIC_DEFAULT_OPUS_MODEL = "claude-opus-4-6";
      ANTHROPIC_DEFAULT_SONNET_MODEL = "claude-sonnet-4-6";
      ANTHROPIC_DEFAULT_HAIKU_MODEL = "claude-haiku-4-5-20251001";
      CLAUDE_CODE_SUBAGENT_MODEL = "claude-opus-4-6";
      CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS = "1";
      CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
    };
  };
in
{
  home.packages = [ claudePackage ];

  home.file.".claude/settings.json".text = builtins.toJSON claudeSettings;
}
