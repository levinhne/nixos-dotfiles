{ ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Run dynamically linked binaries built for generic Linux (e.g. VS Code serve-web node)
  programs.nix-ld.enable = true;
}
