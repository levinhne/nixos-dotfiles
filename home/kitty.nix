{ config, pkgs, fonts, theme, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = fonts.terminal;
      size = 10.3;
    };
    settings = {
      # --- TRẢI NGHIỆM NGƯỜI DÙNG ---
      shell = "fish";
      text_composition_strategy = "legacy";
      cursor_trail = 1;
      confirm_os_window_close = 0;
      window_padding_width = 15;

      # --- LINE HEIGHT ---
      # Sử dụng 1.2 hoặc 2px tùy Vinh, ở đây mình dùng cell_height để nới rộng
      modify_font = "cell_height 2px";

      # --- TAB BAR ---
      tab_bar_style = "powerline";
      tab_powerline_style = "round";

      # --- COLORS (SỬ DỤNG BIẾN THEME CỦA VINH) ---
      background = theme.colors.base00;
      foreground = theme.colors.base05;
      cursor = theme.colors.base0D;

      # Tận dụng màu nổi nhất trong theme để làm Selection
      # base0E thường là màu Tím (giống Dracula) hoặc dùng base08 (Đỏ) nếu Vinh muốn rực hơn
      selection_background = theme.colors.base0E;
      # Dùng base00 (màu nền) làm màu chữ khi select để tạo độ tương phản cao
      selection_foreground = theme.colors.base00;

      # --- BẢNG MÀU ANSI ---
      color0 = theme.colors.base00;
      color1 = theme.colors.base08;
      color2 = theme.colors.base0B;
      color3 = theme.colors.base0A;
      color4 = theme.colors.base0D;
      color5 = theme.colors.base0E;
      color6 = theme.colors.base0C;
      color7 = theme.colors.base05;
    };
  };
}
