{ ... }:

let
  shellCommon = import ./common.nix { };
in
{
  # Bash
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = shellCommon.shellAliases;
    historyControl = [
      "ignoredups"
      "erasedups"
    ];
    historyFileSize = 100000;
    historySize = 100000;
    bashrcExtra = ''
      ${shellCommon.posixSecrets}
      ${shellCommon.posixRebuildFunction}
      ${shellCommon.bashInteractiveInit}
    '';
  };
}
