{
  description = "NixOS from Scratch";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    llm-agents.url = "github:numtide/llm-agents.nix";
    disko.url = "github:nix-community/disko";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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
    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      mkHost = import ./lib/mkHost.nix { inherit inputs nixpkgs; };
    in
    {
      nixosConfigurations = {
        nixos-levinhne = mkHost {
          hostname = "nixos-levinhne";
          username = "levinhne";
        };

        nixos-vinhlq21 = mkHost {
          hostname = "nixos-vinhlq21";
          username = "levinhne";
        };
      };
    };
}
