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
            id = "Qwen3-Coder-480B-A35B-Instruct";
            name = "Qwen3-Coder-480B-A35B-Instruct";
            default_max_tokens = 4096;
          }
        ];
      };
    };
    lsp = {
      go = { command = "gopls"; enabled = true; };
      nix = { command = "nil"; enabled = true; };
    };
    options = {
      context_paths = [ "/etc/nixos/configuration.nix" ];
      tui = { compact_mode = true; };
      debug = false;
    };
  };
in
{
  xdg.configFile."crush/crush.json".text = builtins.toJSON crushConfig;
}
