{ inputs, nixpkgs }:

{ hostname
, username
, system ? "x86_64-linux"
,
}:

let
  inherit (inputs) agenix disko home-manager nix-colors nixpkgs-unstable;

  pkgsUnstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = {
    inherit hostname inputs username;
    pkgs-unstable = pkgsUnstable;
  };

  modules = [
    disko.nixosModules.disko
    agenix.nixosModules.default
    ./../hosts/${hostname}/disko.nix
    ./../hosts/${hostname}/default.nix
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${username} = import ./../home/default.nix;
        backupFileExtension = "backup";
        extraSpecialArgs = {
          inherit hostname inputs nix-colors username;
          pkgs-unstable = pkgsUnstable;
        };
      };
    }
  ];
}
