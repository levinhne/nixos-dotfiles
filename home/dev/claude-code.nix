{ lib, pkgs, pkgs-unstable, ... }:

let
  claudePackage =
    if pkgs-unstable ? claude-code then
      pkgs-unstable.claude-code
    else if pkgs ? claude-code then
      pkgs.claude-code
    else
      null;

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
    };
  };
in
{
  home.packages = lib.optional (claudePackage != null) claudePackage;

  home.file.".claude/settings.json".text = builtins.toJSON claudeSettings;
}
