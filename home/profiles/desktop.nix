# Desktop profile - Full desktop environment with window managers
# This profile includes all desktop tools, shells, and UI configurations
{ config, pkgs, pkgs-unstable, ... }:

let
  theme = import ../theme.nix;
  fonts = {
    ui = "FiraCode Nerd Font";
    terminal = "FiraCode Nerd Font Med";
  };
in
{
  _module.args = { inherit theme fonts; };

  imports = [
    ../core.nix
    ../crush.nix
    ../gtk.nix
    ../pkgs.nix
    ../shell/bash.nix
    ../shell/git.nix
    ../shell/fish.nix
    ../shell/starship.nix
    ../shell/tmux.nix
    ../wm/sway.nix
    ../wm/niri.nix
    ../wm/waybar.nix
    ../wm/mako.nix
    ../kitty.nix
    ../foot.nix
    ../wpaperd.nix
  ];
}
