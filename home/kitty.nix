{ config, pkgs, fonts, theme, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = fonts.terminal;
      size = 10.3;
    };
    settings = {
      shell = "fish";
      text_composition_strategy = "legacy";
      cursor_trail = 1;
      tab_bar_style = "powerline";
      tab_powerline_style = "round";

      window_padding_width = 15;
      confirm_os_window_close = 0;

      background = theme.colors.base00;
      foreground = theme.colors.base05;
      cursor = theme.colors.base0D;
      selection_background = theme.colors.base01;

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
