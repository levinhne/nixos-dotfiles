{ config, pkgs, ... }:

{
  programs.wpaperd = {
    enable = true;
    settings = {
      DP-1 = {
        path = "${config.home.homeDirectory}/.wallpapers";
        mode = "fit";
      };
      HDMI-A-1 = {
        path = "${config.home.homeDirectory}/.wallpapers";
        mode = "fit";
      };
    };
  };
}
