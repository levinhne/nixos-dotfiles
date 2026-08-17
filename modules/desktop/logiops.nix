{ ... }:

{
  # Driver userspace cho chuột Logitech HID++ (MX Master, MX Anywhere, ...)
  services.logiops = {
    enable = true;
    config = {
      devices = [
        {
          name = "Wireless Mouse MX Master 3S";
          dpi = 1000;
          smartshift = {
            on = true;
            threshold = 15;
          };
          hiresscroll = {
            hires = true;
            invert = false;
            target = false;
          };
          buttons = [
            # Nút gesture (dưới bánh xe ngón cái): giữ + vuốt để đổi workspace
            {
              cid = "0x53";
              action = {
                type = "Gestures";
                gestures = [
                  {
                    direction = "Up";
                    mode = "OnRelease";
                    action = {
                      type = "Keypress";
                      keys = [ "KEY_LEFTMETA" "KEY_UP" ];
                    };
                  }
                  {
                    direction = "Down";
                    mode = "OnRelease";
                    action = {
                      type = "Keypress";
                      keys = [ "KEY_LEFTMETA" "KEY_DOWN" ];
                    };
                  }
                  {
                    direction = "Left";
                    mode = "OnRelease";
                    action = {
                      type = "Keypress";
                      keys = [ "KEY_LEFTMETA" "KEY_LEFT" ];
                    };
                  }
                  {
                    direction = "Right";
                    mode = "OnRelease";
                    action = {
                      type = "Keypress";
                      keys = [ "KEY_LEFTMETA" "KEY_RIGHT" ];
                    };
                  }
                ];
              };
            }
          ];
        }
      ];
    };
  };
}
