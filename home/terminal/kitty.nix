{ config, pkgs, fonts, ... }:

let
  p = config.lib.stylix.colors;
in
{
  programs.kitty = {
    enable = true;
    font = {
      name = fonts.terminal;
      size = 10.3;
    };
    settings = {
      # --- TRẢI NGHIỆM NGƯỜI DÙNG ---
      text_composition_strategy = "legacy";
      background_opacity = "0.98";
      # cursor_trail = 1;
      confirm_os_window_close = 0;
      window_padding_width = 2.5;

      # --- LINE HEIGHT ---
      modify_font = "cell_height 2px";

      # --- COLORS ---
      background = "#${p.base00}";
      foreground = "#${p.base05}";
      cursor = "#${p.base0D}";

      selection_background = "#${p.base0E}";
      selection_foreground = "#${p.base00}";

      # --- BẢNG MÀU ANSI ---
      color0 = "#${p.base00}";
      color1 = "#${p.base08}";
      color2 = "#${p.base0B}";
      color3 = "#${p.base0A}";
      color4 = "#${p.base0D}";
      color5 = "#${p.base0E}";
      color6 = "#${p.base0C}";
      color7 = "#${p.base05}";
    };
  };
}
