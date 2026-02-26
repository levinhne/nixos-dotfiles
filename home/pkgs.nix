{ pkgs, ... }:

let
  # Custom packages
  retrosmart-cursors = pkgs.callPackage ../packages/retrosmart-cursors.nix {};
in
{
  # CLI tools
  home.packages = with pkgs; [
    ripgrep
    fd
    fzf
    bat
    eza
    tree
    foot
    neovim
    qutebrowser
    google-chrome
    wpaperd
    bemenu
    openssl

    # Dev:
    opencode
    vscode
    lazygit
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
