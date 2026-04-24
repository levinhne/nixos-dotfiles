{ pkgs }:

{
  retrosmart-cursors = pkgs.callPackage ./retrosmart-cursors.nix { };
  webdiff = pkgs.callPackage ./webdiff.nix { };
}
