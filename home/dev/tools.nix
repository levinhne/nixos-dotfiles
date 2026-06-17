{ inputs, pkgs, ... }:

let
  llmPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};

  crushConfig = {
    "$schema" = "https://charm.land/crush.json";
    providers = {
      fpt = {
        id = "fpt";
        name = "FPT AI";
        base_url = "https://mkp-api.fptcloud.com/v1";
        type = "openai-compat";
        api_key = "$FPT_API_KEY";
        models = [
          {
            id = "GLM-5.1";
            name = "GLM-5.1";
            default_max_tokens = 8192;
            can_reason = false;
            cost_per_1m_in = 0.1;
            cost_per_1m_out = 0.1;
            context_window = 128000;
          }
          {
            id = "DeepSeek-V4-Flash";
            name = "DeepSeek V4 Flash";
            default_max_tokens = 8192;
            can_reason = false;
            cost_per_1m_in = 0.1;
            cost_per_1m_out = 0.1;
            context_window = 128000;
          }
        ];
      };
    };
    lsp = {
      go = { command = "gopls"; enabled = true; };
      nix = { command = "nil"; enabled = true; };
    };
    options = { };
  };
in
{
  home.packages = [
    pkgs.aider-chat
    pkgs.direnv
    pkgs.repomix
    pkgs.webdiff
    llmPkgs.claude-code
    llmPkgs.crush
    llmPkgs.opencode
    llmPkgs.antigravity-cli
  ];

  xdg.configFile."crush/crush.json".text = builtins.toJSON crushConfig;
}
