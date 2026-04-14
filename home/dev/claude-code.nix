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
      CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS = "1";
      CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
    };
  };
in
{
  home.packages = [ claudePackage ];

  home.file.".claude/settings.json".text = builtins.toJSON claudeSettings;
}
