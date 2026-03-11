{ pkgs, ... }:

let
  shellCommon = import ./common.nix { };
in
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting ""
      ${shellCommon.fishSecrets}
      direnv hook fish | source
    '';
    plugins = [
      { name = "bass"; src = pkgs.fishPlugins.bass.src; }
      { name = "done"; src = pkgs.fishPlugins.done.src; }
      { name = "z"; src = pkgs.fishPlugins.z.src; }
    ];
    shellAbbrs = {
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-levinhne";
      v = "nvim";
    };
  };
}
