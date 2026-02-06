{ config, pkgs, term_font, ... }:

{
  programs.kitty = {
    enable = true;
    environment = {
      "LS_COLORS" = "1";
    };
    font = {
      name = term_font;
      size = 12;
    };
    settings = {
      text_composition_strategy = "legacy";
      cursor_trail = 1;
      tab_bar_style = "powerline";
      tab_powerline_style = "round";

      window_padding_width = 15;
      confirm_os_window_close = 0;
    };
  };
}
