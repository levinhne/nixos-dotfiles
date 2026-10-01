{ config, pkgs, ... }:

{
  # Cloudflare Tunnel configuration
  # TODO: chuyển credentials sang agenix giống nixos-vinhlq21/cloudflared.nix:
  #   1. secrets/secrets.nix: "cloudflared-nixos-levinhne.age".publicKeys = allUsers ++ [ nixos-levinhne ];
  #   2. cd secrets && agenix -e cloudflared-nixos-levinhne.age < ~/.cloudflared/<tunnel-id>.json
  #   3. age.secrets.cloudflared-nixos-levinhne.file = ../../secrets/cloudflared-nixos-levinhne.age;
  #      credentialsFile = config.age.secrets.cloudflared-nixos-levinhne.path;

  services.cloudflared = {
    enable = true;
    package = pkgs.cloudflared;
    tunnels = {
      "b88c50c9-86ee-4d6d-b4cd-442ac7122d43" = {
        credentialsFile = "/home/${config.mySystem.userName}/.cloudflared/b88c50c9-86ee-4d6d-b4cd-442ac7122d43.json";
        default = "http_status:404";
        ingress = { };
      };
    };
  };
}
