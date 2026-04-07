{ inputs, pkgs, ... }:

let
  zeroclawPackage = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.zeroclaw;
in
{
  home.packages = [ zeroclawPackage ];
}
