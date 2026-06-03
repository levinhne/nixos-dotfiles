{ inputs }:

final: prev: {
  # Remove once nixpkgs bemenu includes the Smithay/Niri --center fix.
  bemenu = prev.bemenu.overrideAttrs (_old: {
    version = "0.6.23-unstable-2025-07-22";
    src = final.fetchFromGitHub {
      owner = "Cloudef";
      repo = "bemenu";
      rev = "249f18f4d4b3ab7a338fe879d53f4edc01d18c9c";
      hash = "sha256-ZMpYo+oxySG5+bOgKNWUQScSE8mzCwB0DSU1hqEWNGA=";
    };
  });

  retrosmart-cursors = final.callPackage ../packages/retrosmart-cursors.nix { };
  webdiff = final.callPackage ../packages/webdiff.nix { };
}
