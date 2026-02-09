{ config, pkgs, ... }:

let
  term_font = "FiraCode Nerd Font Ret";
  theme = import ../../home/theme.nix;
  fonts = {
    ui = "FiraCode Nerd Font";
    terminal = "FiraCode Nerd Font Med";
  };
in
{
  _module.args = { inherit term_font theme fonts; };

  imports = [
    ../../home/core.nix
    ../../home/gtk.nix
    ../../home/pkgs.nix
    ../../home/shell/bash.nix
    ../../home/shell/git.nix
    ../../home/shell/fish.nix
    ../../home/shell/starship.nix
    ../../home/wm/sway.nix
    ../../home/wm/waybar.nix
    ../../home/wm/mako.nix
    ../../home/kitty.nix
    ../../home/foot.nix
    ../../home/wpaperd.nix
  ];
}
