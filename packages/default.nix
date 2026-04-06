{ pkgs }:

{
  crush = pkgs.callPackage ./crush.nix { };
  retrosmart-cursors = pkgs.callPackage ./retrosmart-cursors.nix { };
  webdiff = pkgs.callPackage ./webdiff.nix { };
}
