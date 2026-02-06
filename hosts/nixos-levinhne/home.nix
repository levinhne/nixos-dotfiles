{ config, pkgs, ... }:

let
  term_font = "Fira Code";
in
{
  _module.args = { inherit term_font; };

  imports = [
    ../../home/core.nix
    ../../home/pkgs.nix
    ../../home/shell/bash.nix
    ../../home/shell/git.nix
    ../../home/wm/sway.nix
    ../../home/wm/waybar.nix
    ../../home/wm/mako.nix
    ../../home/kitty.nix
    ../../home/foot.nix
    ../../home/wpaperd.nix
  ];
}
