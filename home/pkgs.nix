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
    foot
    neovim
    qutebrowser
    google-chrome
    wpaperd
    bemenu

    # Dev:
    opencode
    vscode
    nodejs_24
    python3
    nwg-displays
    # nix
    nixpkgs-fmt
  ];
}
