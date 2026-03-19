{ pkgs, pkgs-unstable, ... }:

let
  retrosmart-cursors = pkgs.callPackage ../../packages/retrosmart-cursors.nix { };
in
{
  home.packages = with pkgs; [
    ripgrep
    fd
    fzf
    bat
    eza
    jq
    tree
    foot
    neovim
    qutebrowser
    google-chrome
    wpaperd
    bemenu
    vscode
    lazygit
    pkgs-unstable.crush
    pkgs-unstable.antigravity
    pkgs-unstable.codex
    pkgs-unstable.opencode
    nodejs_24
    python3
    direnv
    k9s
    podman-tui
    nixpkgs-fmt
    retrosmart-cursors
  ];
}
