{ pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    bat
    eza
    jq
    tree
    qutebrowser
    google-chrome
    firefox
    wpaperd
    bemenu
    vscode
    git-extras
    crush
    pkgs-unstable.antigravity
    pkgs-unstable.codex
    k9s
    podman-tui
    nixpkgs-fmt
    retrosmart-cursors
  ];
}
