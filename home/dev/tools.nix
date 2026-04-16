{ inputs, pkgs, ... }:

let
  llmPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = [
    pkgs.aider-chat
    pkgs.direnv
    pkgs.repomix
    pkgs.webdiff
    llmPkgs.gitnexus
    llmPkgs.mcporter
  ];
}
