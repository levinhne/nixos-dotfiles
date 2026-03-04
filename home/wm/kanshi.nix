{ pkgs, ... }:

{
  # Kanshi - automatic display configuration
  services.kanshi = {
    enable = true;

    settings = [
      # Profile 1: Công ty - Dual monitor (HDMI-A-1 + DP-1)
      # Cả 2 màn hình đều 1920x1080@75Hz
      {
        profile = {
          name = "work-dual";
          outputs = [
            {
              criteria = "HDMI-A-1";
              mode = "1920x1080@75Hz";
              position = "0,0";
              scale = 1.0;
            }
            {
              criteria = "DP-1";
              mode = "1920x1080@75Hz";
              position = "1920,0";
              scale = 1.0;
            }
          ];
        };
      }

      # Profile 2: Nhà - Single monitor HDMI only
      {
        profile = {
          name = "home-single";
          outputs = [
            {
              criteria = "HDMI-A-1";
              mode = "1920x1200@74.930Hz";
              position = "0,0";
              scale = 1.0;
            }
          ];
        };
      }
    ];
  };
}
