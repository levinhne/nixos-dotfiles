{ config, pkgs, ... }:

{
  # Cloudflare Tunnel configuration for work laptop.
  # Credentials: secrets/cloudflared-nixos-vinhlq21.age (agenix, root-only;
  # cloudflared reads it through systemd LoadCredential).
  age.secrets.cloudflared-nixos-vinhlq21.file = ../../secrets/cloudflared-nixos-vinhlq21.age;

  services.cloudflared = {
    enable = true;
    package = pkgs.cloudflared;
    tunnels = {
      "nixos-vinhlq21" = {
        credentialsFile = config.age.secrets.cloudflared-nixos-vinhlq21.path;
        default = "http_status:404";
        ingress = {
          "nixos-vinhlq21-ssh.levinh.io.vn" = "ssh://localhost:22";
        };
      };
    };
  };
}
