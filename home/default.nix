{ username ? "levinhne", ... }:

{
  imports = [
    ./profiles/desktop.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
}
