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
      ${shellCommon.fishInteractiveInit}
    '';
    functions = {
      nrs = {
        description = "Switch the current NixOS host configuration";
        body = shellCommon.fishRebuildFunction;
      };
    };
    plugins = [
      { name = "bass"; src = pkgs.fishPlugins.bass.src; }
      { name = "done"; src = pkgs.fishPlugins.done.src; }
      { name = "z"; src = pkgs.fishPlugins.z.src; }
    ];
    shellAliases = shellCommon.shellAliases;
  };
}
