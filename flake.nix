{
  description = "NixOS from Scratch";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, disko, home-manager, agenix, ... }: {
    nixosConfigurations.nixos-levinhne = let
      pkgsUnstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { pkgs-unstable = pkgsUnstable; };
      modules = [
        disko.nixosModules.disko
        agenix.nixosModules.default
        ./hosts/nixos-levinhne/disko.nix
        ./hosts/nixos-levinhne/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.levinhne = import ./hosts/nixos-levinhne/home.nix;
            backupFileExtension = "backup";
            extraSpecialArgs = { pkgs-unstable = pkgsUnstable; };
          };
        }
      ];
    };
    nixosConfigurations.nixos-office-levinhne = let
      pkgsUnstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { pkgs-unstable = pkgsUnstable; };
      modules = [
        disko.nixosModules.disko
        agenix.nixosModules.default
        ./hosts/nixos-levinhne/disko.nix
        ./hosts/nixos-office-levinhne/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.levinhne = import ./hosts/nixos-office-levinhne/home.nix;
            backupFileExtension = "backup";
            extraSpecialArgs = { pkgs-unstable = pkgsUnstable; };
          };
        }
      ];
    };
    packages.x86_64-linux.agenix = agenix.packages.x86_64-linux.default;
  };
}
