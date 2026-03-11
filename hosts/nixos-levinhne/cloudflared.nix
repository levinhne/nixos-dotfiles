{ config, pkgs, ... }:

{
  # Cloudflare Tunnel configuration
  # TODO: Move credentials to agenix secrets for better security
  # Example:
  #   1. Encrypt: agenix -e secrets/cloudflared-levinhne.age
  #   2. Declare in system/secrets.nix:
  #      age.secrets.cloudflared-levinhne = {
  #        file = ../secrets/cloudflared-levinhne.age;
  #        owner = config.mySystem.userName;
  #      };
  #   3. Use: credentialsFile = config.age.secrets.cloudflared-levinhne.path;
  
  services.cloudflared = {
    enable = true;
    package = pkgs.cloudflared;
    tunnels = {
      "b88c50c9-86ee-4d6d-b4cd-442ac7122d43" = {
        credentialsFile = "/home/${config.mySystem.userName}/.cloudflared/b88c50c9-86ee-4d6d-b4cd-442ac7122d43.json";
        default = "http_status:404";
        ingress = {
          "vinhtest.levinh.io.vn" = "http://127.0.0.1:8000";
        };
      };
    };
  };
}
