{ pkgs, ... }:

{
  services.cloudflared = {
    enable = true;
    package = pkgs.cloudflared;
    tunnels = {
      "nixos-vinhlq21" = {
        credentialsFile = "/home/levinhne/.cloudflared/nixos-vinhlq21.json";
        default = "http_status:404";
        ingress = {
          "nixos-vinhlq21-ssh.levinh.io.vn" = "ssh://localhost:22";
        };
      };
    };
  };
}
