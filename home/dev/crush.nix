{ ... }:

let
  crushConfig = {
    "$schema" = "https://charm.land/crush.json";
    providers = {
      openai = {
        id = "openai";
        name = "OpenAI";
        base_url = "https://api.openai.com/v1";
        type = "openai";
        api_key = "$OPENAI_API_KEY";
        models = [
          {
            id = "gpt-4";
            name = "GPT-4";
          }
        ];
      };
      fpt = {
        id = "fpt";
        name = "FPT AI";
        base_url = "https://mkp-api.fptcloud.com/v1";
        type = "openai-compat";
        api_key = "$FPT_API_KEY";
        models = [
          {
            id = "GLM-4.7";
            name = "GLM-4.7";
            default_max_tokens = 8192;
            can_reason = false;
            cost_per_1m_in = 0.1;
            cost_per_1m_out = 0.1;
            context_window = 128000;
          }
        ];
      };
      claudefake = {
        id = "claude fake";
        name = "Claude Fake";
        type = "anthropic";
        base_url = "https://aihubapi.khoapi.dev/";
        api_key = "$CLAUDE_FAKE_API";
        models = [
          {
            id = "claude-sonnet-4-6";
            name = "claude-sonnet-4-6";
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
  xdg.configFile."crush/crush.json".text = builtins.toJSON crushConfig;
}
