{ config, pkgs, term_font, ... }:

{
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "foot";
        font = "${term_font}:size=12, monospace:size=14";
        pad = "25x25";
        dpi-aware = "no";
      };
      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
