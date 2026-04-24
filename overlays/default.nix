{ inputs }:

final: prev: {
  retrosmart-cursors = final.callPackage ../packages/retrosmart-cursors.nix { };
  webdiff = final.callPackage ../packages/webdiff.nix { };
}
