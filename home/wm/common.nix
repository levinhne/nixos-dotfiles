# Common configuration for window managers (Sway and Niri)
# Contains shared settings like bemenu config and startup programs
{ pkgs, fonts, theme }:

let
  c = theme.colors;
  bemenuBaseOptions =
    "--fn 'Iosevka Nerd Font 10.3' " +
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
    "-c -B 2 -W 0.5 -H 28 --hp 10 ";
in
{
  # Common applications
  terminal = "kitty";

  # Bemenu launcher configuration with theme colors
  menu = "bemenu-run " + bemenuBaseOptions + "--prompt 'Run:'";

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
    spawn-at-startup "waybar"
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
    clipboard = "cliphist list | bemenu " + bemenuBaseOptions + "-l 10 --prompt 'Clipboard' | cliphist decode | wl-copy";
  };
}
