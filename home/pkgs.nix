{ pkgs, pkgs-unstable, ... }:

let
  # Custom packages
  retrosmart-cursors = pkgs.callPackage ../packages/retrosmart-cursors.nix { };
in
{
  # CLI tools
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

    # Dev:
    opencode
    vscode
    lazygit
    pkgs-unstable.crush
    pkgs-unstable.antigravity
    nodejs_24
    python3
    direnv
    k9s

    # nix
    nixpkgs-fmt

    # Custom packages
    retrosmart-cursors
  ];
}
