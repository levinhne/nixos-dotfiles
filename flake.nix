{
  description = "NixOS from Scratch";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    disko.url = "github:nix-community/disko";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, disko, home-manager, agenix, nur, ... }: {
    nixosConfigurations.nixos-levinhne = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        agenix.nixosModules.default
        nur.modules.nixos.default
        ./hosts/nixos-levinhne/disko.nix
        ./hosts/nixos-levinhne/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.levinhne = import ./hosts/nixos-levinhne/home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
    packages.x86_64-linux.agenix = agenix.packages.x86_64-linux.default;
  };
}
