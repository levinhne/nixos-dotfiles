{ pkgs, lib, fonts, theme, ... }:

let
  # 1. Các biến cấu hình chung
  modifier = "Mod4";
  terminal = "kitty";

  # 2. Bảng màu từ theme
  c = theme.colors;

  # 3. Cấu hình bemenu (Đã thêm backend wayland để sửa lỗi không chạy)
  menu = "bemenu-run " +
    "--fn '${fonts.ui} 10.3' " +
    "--tb '${c.base00}' --tf '${c.base0D}' " +
    "--fb '${c.base00}' --ff '${c.base05}' " +
    "--nb '${c.base00}' --nf '${c.base05}' " +
    "--hb '${c.base01}' --hf '${c.base0B}' " +
    "--cb '${c.base0D}' --cf '${c.base00}' " +
    "--sb '${c.base01}' --sf '${c.base0E}' " +
    "--ab '${c.base00}' --af '${c.base0C}' " +
    "--fbb '${c.base00}' --fbf '${c.base0C}' " +
    "--scb '${c.base00}' --scf '${c.base0C}' " +
    "--bdr '${c.base0D}' " +
    "-c -B 2 -W 0.5 -H 28 --hp 10 --prompt 'Run:'";

  # 4. Danh sách Workspace (1-9 và 0)
  wsKeys = map (n: toString n) [ 1 2 3 4 5 6 ];
in
{
  # Đảm bảo bemenu được cài đặt
  home.packages = with pkgs; [ bemenu ];

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    xwayland = true;

    config = {
      modifier = modifier;
      terminal = terminal;
      menu = menu;

      fonts = {
        names = [ fonts.ui ];
        size = 11.0;
      };

      output = {
        "HDMI-A-1" = {
          res = "1920x1200";
          pos = "0 0";
        };
      };

      gaps = {
        inner = 4;
        outer = 4;
      };

      window.commands = [
        {
          command = "floating enable";
          criteria = { app_id = "yad"; };
        }
        {
          command = "floating enable, move position center, resize set 600 400";
          criteria = { app_id = "org.pulseaudio.pavucontrol"; };
        }
      ];

      keybindings = lib.mkOptionDefault (
        {
          # Launchers
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+d" = "exec ${menu}";
          "${modifier}+b" = "exec google-chrome-stable";
          "${modifier}+y" = "exec nemo";

          # Utilities
          "${modifier}+v" = "exec cliphist list | rofi -dmenu -p 'Clipboard' -theme ~/.config/rofi/clipboard.rasi | cliphist decode | wl-copy";
          # "${modifier}+s" = "exec rofi -show emoji -modi emoji -matching regex -sorting-method levenshtein";
          # "${modifier}+c" = "exec ~/.local/bin/random-wallpaper.sh";
          "${modifier}+g" = "exec ~/.config/sway/scripts/prompt-record.sh";

          # Window Management
          "${modifier}+w" = "kill";
          "${modifier}+a" = "exec sticky enable";
          "${modifier}+t" = "floating toggle";
          "${modifier}+f" = "fullscreen";
          # "${modifier}+u" = "exec ~/.config/sway/scripts/tiling.sh";

          # System Controls
          "${modifier}+Shift+t" = "exec swaylock --screenshots --effect-blur 7x5 --color '${c.base00}' --indicator-radius 100 --font '${fonts.ui}'";
          "${modifier}+Shift+a" = "exec pkill -SIGUSR2 waybar";
          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut.' -B 'Yes, exit sway' 'swaymsg exit'";
          "ctrl+alt+delete" = "exec nwg-bar";

          # Media Keys
          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
          "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
          "Print" = "exec flameshot gui";
        } //
        # Tự động tạo bindings cho Workspaces
        (builtins.listToAttrs (map
          (i: {
            name = "${modifier}+${i}";
            value = "workspace number ${i}; exec echo 1 > /tmp/sovpipe";
          })
          wsKeys)) //
        (builtins.listToAttrs (map
          (i: {
            name = "${modifier}+Shift+${i}";
            value = "move container to workspace number ${i}";
          })
          wsKeys))
      );

      colors = {
        focused = {
          border = c.base0D;
          background = c.base01;
          text = c.base05;
          indicator = c.base0C;
          childBorder = c.base0D;
        };
        unfocused = {
          border = c.base00;
          background = c.base01;
          text = c.base03;
          indicator = c.base00;
          childBorder = c.base01;
        };
      };

      bars = [{ command = "waybar"; }];

      startup = [
        { command = "autotiling -l 2"; always = true; }
        { command = "wpaperd -d"; always = true; }
        { command = "mako"; always = true; }
        { command = "fcitx5 -d"; }
        { command = "wl-paste --type text --watch cliphist store"; always = true; }
        { command = "blueman-applet"; }
      ];
    };

    extraConfig = ''
      default_border pixel 2
      ${lib.concatMapStringsSep "\n" (i: "bindsym --release ${modifier}+${i} exec \"echo 0 > /tmp/sovpipe\"") wsKeys}
    '';
  };

  programs.swaylock = {
    enable = true;
    settings = {
      color = "${c.base00}";
      ignore-empty-password = true;
      indicator-radius = 120;
    };
  };

  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f -c ${c.base00}"; }
    ];
    timeouts = [
      {
        timeout = 300;
        # Viết tất cả tham số trên 1 dòng để tránh lỗi format systemd unit
        command = "${pkgs.swaylock}/bin/swaylock -f --color ${c.base00} --inside-color ${c.base01} --inside-clear-color ${c.base0C} --inside-ver-color ${c.base0D} --inside-wrong-color ${c.base08} --ring-color ${c.base0D} --ring-clear-color ${c.base0C} --ring-ver-color ${c.base0D} --ring-wrong-color ${c.base08} --key-hl-color ${c.base0B} --bs-hl-color ${c.base08} --separator-color ${c.base01} --text-color ${c.base05} --text-clear-color ${c.base01} --text-ver-color ${c.base01} --text-wrong-color ${c.base01} --indicator-radius 100 --indicator-thickness 10 --font '${fonts.ui}'";
      }
      {
        timeout = 600;
        command = "${pkgs.sway}/bin/swaymsg 'output * power off'";
        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * power on'";
      }
    ];
  };
}
