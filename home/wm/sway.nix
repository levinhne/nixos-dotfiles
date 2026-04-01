{ config, pkgs, lib, fonts, theme, ... }:

let
  common = import ./common.nix { inherit pkgs fonts theme; };
in

let
  # 1. Các biến cấu hình chung
  modifier = "Mod4";
  terminal = common.terminal;
  browser = common.apps.browser;
  clipboard = common.apps.clipboard;

  # 2. Bảng màu từ theme
  c = theme.colors;
  swayConfigPath = "${config.xdg.configHome}/sway/config";

  # 3. Sử dụng bemenu từ common config
  menu = common.menu;

  # 4. Danh sách Workspace (1-9 và 0)
  wsKeys = map (n: toString n) [ 1 2 3 4 5 6 ];
in
{
  # Sway-related packages
  home.packages = with pkgs; [
    # Launcher
    bemenu

    # Sway utilities
    swaybg # Wallpaper
    swaylock-effects # Screen locker with effects (blur, fade, etc.)
    swayidle # Idle management
    autotiling # Auto tiling
    sov # Workspace overview
    (pkgs.writeShellScriptBin "start-sov" ''
      pkill -x sov || true
      rm -f /tmp/sovpipe
      mkfifo /tmp/sovpipe
      # Giữ pipe luôn mở để EOF không bao giờ gửi tới sov khi echo kết thúc
      exec 3<> /tmp/sovpipe
      cat < /tmp/sovpipe | sov -t 500
    '')

    # Wayland utilities
    waybar # Status bar
    wl-clipboard # Clipboard manager
    cliphist # Clipboard history
    grim # Screenshot tool
    slurp # Region selector
    mako # Notification daemon
    libnotify # notify-send command

    # Portals (already enabled in system, but needed for runtime)
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
  ];

  wayland.windowManager.sway = {
    enable = true;
    # wrapperFeatures and xwayland are handled by the system-level sway module

    config = {
      modifier = modifier;
      terminal = terminal;
      menu = menu;

      fonts = {
        names = [ fonts.ui ];
        size = 11.0;
      };

      gaps = {
        inner = 2;
        outer = 2;
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
        {
          command = "exec fcitx5-remote -c";
          criteria = { app_id = "^(kitty|foot)$"; };
        }
      ];

      keybindings = lib.mkForce (
        {
          # Launchers
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+d" = "exec ${menu}";
          "${modifier}+b" = "exec ${browser}";
          "${modifier}+y" = "exec nemo";

          # Utilities
          "${modifier}+v" = "exec ${clipboard}";
          "${modifier}+s" = "exec grim -g \"$(slurp)\" - | tee ~/Pictures/screenshots/shot_$(date +\"%Y-%m-%d-%H-%M-%S\").png | wl-copy && notify-send 'Screenshot saved' 'Region captured'";
          "${modifier}+g" = "exec ~/.config/sway/scripts/prompt-record.sh";

          # Window Management
          "${modifier}+w" = "kill";
          "${modifier}+a" = "exec sticky enable";
          "${modifier}+t" = "floating toggle";
          "${modifier}+f" = "fullscreen";
          # "${modifier}+u" = "exec ~/.config/sway/scripts/tiling.sh";

          # Focus
          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          # Move
          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          # Split
          "${modifier}+semicolon" = "splith";
          "${modifier}+Shift+v" = "splitv";

          # Layout
          "${modifier}+e" = "layout toggle split";
          "${modifier}+Shift+s" = "layout stacking";
          "${modifier}+x" = "layout tabbed";

          # Focus parent/child
          "${modifier}+p" = "focus parent";

          # Scratchpad
          "${modifier}+Shift+minus" = "move scratchpad";
          "${modifier}+minus" = "scratchpad show";

          # Resize mode
          "${modifier}+r" = "mode resize";

          # System Controls
          "${modifier}+Shift+t" = "exec swaylock --screenshots --effect-blur 7x5 --effect-vignette 0.5:0.5 --fade-in 0.2 --color '${c.base00}' --indicator-radius 100 --font '${fonts.ui}' --indicator-image /home/levinhne/.wallpapers/xoai.jpeg";
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

          # Overview
          "${modifier}+Tab" = "exec echo 1 > /tmp/sovpipe";
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
        { command = "start-sov"; always = true; }
        # Import Wayland env vars vào systemd user session, sau đó restart kanshi
        { command = "sh -c 'dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP SWAYSOCK XDG_SESSION_TYPE && systemctl --user restart kanshi.service'"; always = false; }
      ] ++ common.startupPrograms;
    };

    extraConfig = ''
      default_border pixel 2
      ${lib.concatMapStringsSep "\n" (i: "bindsym --release ${modifier}+${i} exec \"echo 0 > /tmp/sovpipe\"") wsKeys}
      bindsym --release ${modifier}+Tab exec "echo 0 > /tmp/sovpipe"
    '';
  };

  xdg.configFile."swayfx/config".text = ''
    include ${swayConfigPath}

    # SwayFX-only visual effects layered on top of the shared Sway config.
    corner_radius 4
    default_dim_inactive 0.06

    shadows enable
    shadow_blur_radius 12
    shadow_color ${c.base00}88

    blur enable
    blur_radius 6
    blur_passes 3
    blur_xray false
  '';

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      color = "${c.base00}";
      ignore-empty-password = true;
      indicator-radius = 120;
      # Swaylock-effects specific options
      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";
      fade-in = 0.2;
    };
  };

  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock-effects}/bin/swaylock -f -c ${c.base00} --effect-blur 7x5 --fade-in 0.2"; }
    ];
    timeouts = [
      {
        timeout = 300;
        # Viết tất cả tham số trên 1 dòng để tránh lỗi format systemd unit
        command = "${pkgs.swaylock-effects}/bin/swaylock -f --color ${c.base00} --effect-blur 7x5 --effect-vignette 0.5:0.5 --fade-in 0.2 --inside-color ${c.base01} --inside-clear-color ${c.base0C} --inside-ver-color ${c.base0D} --inside-wrong-color ${c.base08} --ring-color ${c.base0D} --ring-clear-color ${c.base0C} --ring-ver-color ${c.base0D} --ring-wrong-color ${c.base08} --key-hl-color ${c.base0B} --bs-hl-color ${c.base08} --separator-color ${c.base01} --text-color ${c.base05} --text-clear-color ${c.base01} --text-ver-color ${c.base01} --text-wrong-color ${c.base01} --indicator-radius 100 --indicator-thickness 10 --font '${fonts.ui}'";
      }
    ];
  };
}
