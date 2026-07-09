# Common configuration for window managers (Sway and Niri)
# Contains shared settings like rofi config and startup programs
{ pkgs, fonts, palette, paletteWithHash }:

{
  # Common applications
  terminal = "kitty";

  # Rofi launcher
  menu = "rofi -show drun";

  # Common startup programs (for Sway format)
  startupPrograms = [
    { command = "wpaperd -d"; always = true; }
    { command = "mako"; always = true; }
    { command = "fcitx5 -d"; }
    { command = "wl-paste --type text --watch cliphist store"; always = true; }
    { command = "blueman-applet"; }
  ];

  # Common startup programs (for Niri KDL format)
  startupProgramsKdl = ''
    spawn-at-startup "sh" "-c" "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP NIRI_SOCKET XDG_SESSION_TYPE; systemctl --user restart wpaperd.service kanshi.service swayidle.service waybar.service"
    spawn-at-startup "mako"
    spawn-at-startup "fcitx5" "-r"
    spawn-at-startup "sh" "-c" "wl-paste --type text --watch cliphist store"
    spawn-at-startup "blueman-applet"
  '';

  # Common keybindings applications
  apps = {
    browser = "google-chrome-stable";
    fileManager = "nemo";
    screenshot = "grimblast copy area";
    screenshotFull = "grimblast copy output";
    clipboard = "cliphist list | rofi -dmenu -p 'Clipboard' | cliphist decode | wl-copy";
  };
}
