{ ... }:

let
  shellCommon = import ./common.nix { };
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = shellCommon.shellAliases // shellCommon.posixShellAliases;
    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      save = 100000;
      share = true;
      size = 100000;
    };
    initContent = ''
      ${shellCommon.posixSecrets}
      ${shellCommon.posixRebuildFunction}
      ${shellCommon.posixRebuildHostFunction}
      ${shellCommon.zshInteractiveInit}
    '';
  };
}
