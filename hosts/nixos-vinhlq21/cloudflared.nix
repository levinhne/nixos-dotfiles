{ config, pkgs, ... }:

{
  # Cloudflare Tunnel configuration for work laptop
  # TODO: Move credentials to agenix secrets for better security
  # See nixos-levinhne/cloudflared.nix for example
  
  services.cloudflared = {
    enable = true;
    package = pkgs.cloudflared;
    tunnels = {
      "nixos-vinhlq21" = {
        credentialsFile = "/home/${config.mySystem.userName}/.cloudflared/nixos-vinhlq21.json";
        default = "http_status:404";
        ingress = {
          "nixos-vinhlq21-ssh.levinh.io.vn" = "ssh://localhost:22";
        };
      };
    };
  };
}
