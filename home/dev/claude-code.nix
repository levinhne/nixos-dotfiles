{ inputs, pkgs, ... }:

let
  claudePackage = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;

in
{
  home.packages = [ claudePackage ];
}
