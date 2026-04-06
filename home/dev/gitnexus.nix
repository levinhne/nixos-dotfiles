{ inputs, pkgs, ... }:

let
  gitnexusPackage = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.gitnexus;
in
{
  home.packages = [ gitnexusPackage ];
}
