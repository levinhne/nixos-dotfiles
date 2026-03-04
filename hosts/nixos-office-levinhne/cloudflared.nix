{ pkgs-unstable, ... }:

{
  services.cloudflared = {
    enable = true;
    package = pkgs-unstable.cloudflared;
    tunnels = {
      "a3fbc93d-6265-491b-9faf-6fb95e3fd855" = {
        credentialsFile = "/home/levinhne/.cloudflared/a3fbc93d-6265-491b-9faf-6fb95e3fd855.json";
        default = "http_status:404";
        ingress = {
          "ssh-office.levinh.io.vn" = "ssh://localhost:22";
        };
      };
    };
  };
}
