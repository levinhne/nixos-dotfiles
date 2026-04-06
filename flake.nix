{
  description = "NixOS from Scratch";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    llm-agents.url = "github:numtide/llm-agents.nix";
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
    nix-colors.url = "github:misterio77/nix-colors";
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
