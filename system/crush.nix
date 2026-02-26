{ config, pkgs, ... }:

{
  imports = [
    <nur/repos/charmbracelet/modules/crush>
  ];

  programs.crush = {
    enable = true;
    settings = {
      providers = {
        fpt-ai = {
          id = "fpt-ai";
          name = "FPT AI";
          base_url = "https://mkp-api.fptcloud.com/v1";
          type = "openai";
          api_key = "sk-VdJyeJeIZ3sCAVgUP0cF3YdbEHYK4Ym9xPk4z8uTv7kyHqs2"; 
          models = [
            {
              id = "gpt-oss-120b";
              name = "GPT OSS 120B";
            }
          ];
        };
      };
      lsp = {
        go = { command = "gopls"; enabled = true; };
        nix = { command = "nil"; enabled = true; };
        rust = { command = "rust-analyzer"; enabled = true; };
        typescript = { command = "typescript-language-server"; enabled = true; };
      };
      options = {
        context_paths = [ "/etc/nixos/configuration.nix" ];
        tui = { compact_mode = true; };
        debug = false;
      };
    };
  };
}
