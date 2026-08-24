{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
    userSettings = {
      project_panel = {
        dock = "right";
      };
      agent = {
        sidebar_side = "right";
        favorite_models = [ ];
        model_parameters = [ ];
      };
      buffer_line_height = "standard";
      buffer_font_weight = 400.0;
      buffer_font_family = "FiraCode Nerd Font";
      ui_font_size = 16;
      buffer_font_size = 15;
      theme = {
        mode = "dark";
        light = "One Light";
        dark = "Dracula";
      };
      language_models = {
        openai_compatible = {
          fpt = {
            api_url = "https://mkp-api.fptcloud.com/v1";
            available_models = [
              {
                name = "glm-5.2";
                display_name = "GLM-5.2";
                max_tokens = 128000;
                max_output_tokens = 8192;
                capabilities = {
                  tools = true;
                  images = false;
                  parallel_tool_calls = true;
                };
              }
              {
                name = "DeepSeek-V4-Flash";
                display_name = "DeepSeek V4 Flash";
                max_tokens = 128000;
                max_output_tokens = 8192;
                capabilities = {
                  tools = true;
                  images = false;
                  parallel_tool_calls = true;
                };
              }
            ];
          };
        };
      };
    };
  };
}
