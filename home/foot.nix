{ config, pkgs, term_font, ... }:

{
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "foot";
        font = "${term_font}:size=10.3, monospace:size=9";
        pad = "25x25";
        dpi-aware = "no";
      };
      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
