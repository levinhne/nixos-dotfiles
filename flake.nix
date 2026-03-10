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
    fcitx5-lotus = {
      url = "github:LotusInputMethod/fcitx5-lotus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, disko, home-manager, agenix, ... }: {
    nixosConfigurations.nixos-levinhne =
      let
        pkgsUnstable = import nixpkgs-unstable {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
      in
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { pkgs-unstable = pkgsUnstable; inherit inputs; };
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
              extraSpecialArgs = { pkgs-unstable = pkgsUnstable; inherit inputs; };
            };
          }
        ];
      };
    nixosConfigurations.nixos-vinhlq21 =
      let
        pkgsUnstable = import nixpkgs-unstable {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
      in
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { pkgs-unstable = pkgsUnstable; inherit inputs; };
        modules = [
          disko.nixosModules.disko
          agenix.nixosModules.default
          ./hosts/nixos-levinhne/disko.nix
          ./hosts/nixos-vinhlq21/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.levinhne = import ./hosts/nixos-vinhlq21/home.nix;
              backupFileExtension = "backup";
              extraSpecialArgs = { pkgs-unstable = pkgsUnstable; inherit inputs; };
            };
          }
        ];
      };
    packages.x86_64-linux.agenix = agenix.packages.x86_64-linux.default;
  };
}
