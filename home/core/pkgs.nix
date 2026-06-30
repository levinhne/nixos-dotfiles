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
    pkgs-unstable.antigravity
    pkgs-unstable.codex
    k9s
    kubectl
    podman-tui
    nixpkgs-fmt
    retrosmart-cursors
    ffmpeg
  ];
}
