{ config, pkgs, fonts, ... }:

{
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "foot";
        font = "${fonts.terminal}:size=10.3, monospace:size=9";
        pad = "25x25";
        dpi-aware = "no";
      };
      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
