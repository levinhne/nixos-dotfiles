{ pkgs, lib, term_font, ... }:

let
  # Định nghĩa bộ màu Dracula
  dracula = {
    bg0 = "#282a36";
    bg1 = "#44475a";
    fg = "#f8f8f2";
    green = "#50fa7b";
    blue = "#6272a4";
    yellow = "#f1fa8c";
    gray = "#6272a4";
    red = "#ff5555";
    magenta = "#ff79c6";
    cyan = "#8be9fd";
    purple = "#bd93f9";
    orange = "#ffb86c";
  };
in
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    xwayland = true;

    config = rec {
      modifier = "Mod4";
      terminal = "foot";

      # Font
      fonts = {
        names = [ term_font ];
        size = 11.0;
      };

      # Output
      output = {
        "HDMI-A-1" = { res = "1920x1200"; pos = "0 0"; };
        "DP-1" = { res = "1920x1080"; pos = "1920 0"; };
      };

      # Gaps & Borders
      gaps = {
        inner = 4;
        outer = 4;
      };

      # Window Rules
      window.commands = [
        { command = "floating enable"; criteria = { app_id = "yad"; }; }
        { command = "floating enable, move position center, resize set 600 400"; criteria = { app_id = "org.pulseaudio.pavucontrol"; }; }
      ];

      # Keybindings (Tích hợp phím tắt cũ vào bộ mới)
      keybindings = let mod = modifier; in lib.mkOptionDefault {
        # Launchers
        "${mod}+Return" = "exec ${terminal}";
        "${mod}+b" = "exec google-chrome-stable";
        "${mod}+y" = "exec nemo";

        # Utilities
        "${mod}+v" = "exec cliphist list | rofi -dmenu -p 'Clipboard' -theme ~/.config/rofi/clipboard.rasi | cliphist decode | wl-copy";
        "${mod}+s" = "exec rofi -show emoji -modi emoji -matching regex -sorting-method levenshtein";
        "${mod}+c" = "exec ~/.local/bin/random-wallpaper.sh";
        "${mod}+g" = "exec ~/.config/sway/scripts/prompt-record.sh";

        # Window Management
        "${mod}+w" = "kill";
        "${mod}+a" = "exec sticky enable";
        "${mod}+t" = "floating toggle";
        "${mod}+f" = "fullscreen";
        "${mod}+u" = "exec ~/.config/sway/scripts/tiling.sh";

        # System Controls
        "${mod}+Shift+t" = "exec swaylock --screenshots --effect-blur 7x5 --color '${dracula.bg0}' --indicator-radius 100 --font '${term_font}'";
        "${mod}+Shift+a" = "exec pkill -SIGUSR2 waybar";
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut.' -B 'Yes, exit sway' 'swaymsg exit'";
        "ctrl+alt+delete" = "exec nwg-bar";

        # Media Keys
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
        "Print" = "exec flameshot gui";

        # Workspaces với Sov integration
        "${mod}+1" = "workspace number 1; exec echo 1 > /tmp/sovpipe";
        "${mod}+2" = "workspace number 2; exec echo 1 > /tmp/sovpipe";
        "${mod}+3" = "workspace number 3; exec echo 1 > /tmp/sovpipe";
        "${mod}+4" = "workspace number 4; exec echo 1 > /tmp/sovpipe";
        "${mod}+5" = "workspace number 5; exec echo 1 > /tmp/sovpipe";
        "${mod}+6" = "workspace number 6; exec echo 1 > /tmp/sovpipe";
        "${mod}+7" = "workspace number 7; exec echo 1 > /tmp/sovpipe";
        "${mod}+8" = "workspace number 8; exec echo 1 > /tmp/sovpipe";
        "${mod}+9" = "workspace number 9; exec echo 1 > /tmp/sovpipe";
        "${mod}+0" = "workspace number 10; exec echo 1 > /tmp/sovpipe";

        # Move container
        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        # ... Vinh có thể bổ sung thêm từ 4-0 tương tự
      };

      # Dracula Theme Colors
      colors = {
        focused = {
          border = dracula.purple;
          background = dracula.bg1;
          text = dracula.fg;
          indicator = dracula.cyan;
          childBorder = dracula.purple;
        };
        unfocused = {
          border = dracula.bg0;
          background = dracula.bg1;
          text = dracula.gray;
          indicator = dracula.bg0;
          childBorder = dracula.bg1;
        };
      };

      bars = [{ command = "waybar"; }];

      startup = [
        { command = "swww-daemon"; always = true; }
        { command = "mako"; always = true; }
        { command = "wl-paste --type text --watch cliphist store"; always = true; }
      ];
    };

    # Thêm các phím --release cho Sov 
    extraConfig = ''
      default_border pixel 2
      bindsym --release Mod4+1 exec "echo 0 > /tmp/sovpipe" 
      bindsym --release Mod4+2 exec "echo 0 > /tmp/sovpipe" 
      # ... tương tự cho các phím còn lại 
    '';
  };

  # Swayidle + swaylock (lock screen)
  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "swaylock -f -c 000000"; }
    ];
    timeouts = [
      { timeout = 600; command = "swaylock -f -c 000000"; } # 10 phút
    ];
  };

  programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
      ignore-empty-password = true;
      indicator-radius = 120;
    };
  };
}
