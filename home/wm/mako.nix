{ config, ... }:

let
  p = config.lib.stylix.colors;
in
{
  # Mako (notifications)
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      background-color = "#${p.base00}";
      text-color = "#${p.base05}";
      border-color = "#${p.base0D}";

      font = "monospace 8";
    };
  };
}
