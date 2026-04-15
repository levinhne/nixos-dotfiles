{ config, pkgs, fonts, ... }:

let
  p = config.lib.stylix.colors;
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
        background = p.base00;
        foreground = p.base05;

        selection-background = p.base0E;
        selection-foreground = p.base00;

        regular0 = p.base00;
        regular1 = p.base08;
        regular2 = p.base0B;
        regular3 = p.base0A;
        regular4 = p.base0D;
        regular5 = p.base0E;
        regular6 = p.base0C;
        regular7 = p.base05;
      };
    };
  };
}
