{ pkgs, ... }:

{
  services.cloudflared = {
    enable = true;
    package = pkgs.cloudflared;
    tunnels = {
      "7e085885-bbaf-4d28-9b2f-83e63039e3fb" = {
        credentialsFile = "/home/levinhne/.cloudflared/7e085885-bbaf-4d28-9b2f-83e63039e3fb.json";
        default = "http_status:404";
        ingress = {
          "nixos-office-ssh.levinh.io.vn" = "ssh://localhost:22";
        };
      };
    };
  };
}
