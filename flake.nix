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

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, disko, home-manager, agenix, ... }:
    let
      # Helper function to create a NixOS configuration for a host
      mkHost = hostname: username:
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
            ./hosts/${hostname}/disko.nix
            ./hosts/${hostname}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${username} = import ./home/profiles/desktop.nix;
                backupFileExtension = "backup";
                extraSpecialArgs = { pkgs-unstable = pkgsUnstable; inherit inputs; };
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        nixos-levinhne = mkHost "nixos-levinhne" "levinhne";
        nixos-vinhlq21 = mkHost "nixos-vinhlq21" "levinhne";
      };
      
      packages.x86_64-linux.agenix = agenix.packages.x86_64-linux.default;
    };
}
