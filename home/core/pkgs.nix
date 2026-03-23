{ pkgs, pkgs-unstable, ... }:

let
  retrosmart-cursors = pkgs.callPackage ../../packages/retrosmart-cursors.nix { };
in
{
  home.packages = with pkgs; [
    bat
    eza
    jq
    tree
    foot
    kitty
    qutebrowser
    google-chrome
    wpaperd
    bemenu
    vscode
    git-extras
    crush
    pkgs-unstable.antigravity
    pkgs-unstable.codex
    pkgs-unstable.opencode
    direnv
    k9s
    podman-tui
    nixpkgs-fmt
    retrosmart-cursors
  ];
}
