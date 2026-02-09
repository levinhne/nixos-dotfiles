{ config, pkgs, fonts, theme, lib, ... }: # Nhớ thêm lib vào tham số đầu vào

let
  # Hàm tiện ích để xóa dấu # khỏi mã màu hex
  cleanHex = color: lib.removePrefix "#" color;
in
{
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "foot";
        font = "${fonts.terminal}:size=10.3, monospace:size=9";
        line-height = "14"; 
        pad = "10x10";
        dpi-aware = "no";
      };

      mouse = {
        hide-when-typing = "yes";
      };

      colors = {
        # Sử dụng hàm cleanHex để loại bỏ dấu #
        background = cleanHex theme.colors.base00;
        foreground = cleanHex theme.colors.base05;

        selection-background = cleanHex theme.colors.base0E;
        selection-foreground = cleanHex theme.colors.base00;

        regular0 = cleanHex theme.colors.base00;
        regular1 = cleanHex theme.colors.base08;
        regular2 = cleanHex theme.colors.base0B;
        regular3 = cleanHex theme.colors.base0A;
        regular4 = cleanHex theme.colors.base0D;
        regular5 = cleanHex theme.colors.base0E;
        regular6 = cleanHex theme.colors.base0C;
        regular7 = cleanHex theme.colors.base05;
      };
    };
  };
}
