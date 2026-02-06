{ config, pkgs, ... }:

{
  services.wpaperd = {
    enable = true;
    settings = {
      DP-1 = {
        path = ../.wallpapers;
        mode = "tile";
      };
      HDMI-A-1 = {
        path = ../.wallpapers;
        mode = "stretch";
        duration = "1m";
      };
    };
  };
}
