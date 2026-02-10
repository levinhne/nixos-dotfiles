{ config, pkgs, ... }:

{
  services.wpaperd = {
    enable = true;
    settings = {
      default = {
        duration = "1m";
      };
      DP-1 = {
        path = ../.wallpapers;
        mode = "stretch";
      };
      HDMI-A-1 = {
        path = ../.wallpapers;
        mode = "stretch";
      };
    };
  };
}
