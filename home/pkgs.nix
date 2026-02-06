{ pkgs, ... }:

{
  # CLI tools
  home.packages = with pkgs; [
    ripgrep
    fd
    fzf
    bat
    eza
    tree
    code
    foot
    swww
    neovim

    # Dev:
    nodejs_24
    python3
    nwg-displays
    nixpkgs-fmt
  ];
}
