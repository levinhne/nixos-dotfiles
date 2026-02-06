{ config, pkgs, ... }:

{
  imports = [
    ./home/core.nix
    ./home/pkgs.nix
    ./home/shell/bash.nix
    ./home/shell/git.nix
    ./home/wm/sway.nix
    ./home/wm/waybar.nix
    ./home/wm/wofi.nix
    ./home/wm/mako.nix
  ];
}
