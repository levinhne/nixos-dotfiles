{ inputs, pkgs, ... }:

let
  opencodePackage = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode;
in
{
  home.packages = [ opencodePackage ];

  xdg.configFile."opencode/opencode.json".text =
    builtins.readFile ../../config/opencode/opencode.json;
}
