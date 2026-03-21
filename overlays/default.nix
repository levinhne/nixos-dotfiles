{ inputs }:

final: prev: {
  retrosmart-cursors = final.callPackage ../packages/retrosmart-cursors.nix { };
  crush = final.callPackage ../packages/crush.nix { };
}
