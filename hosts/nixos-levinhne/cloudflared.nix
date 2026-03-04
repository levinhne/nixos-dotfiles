{ pkgs, ... }:

{
  services.cloudflared = {
    enable = true;
    package = pkgs.cloudflared;
    tunnels = {
      "b88c50c9-86ee-4d6d-b4cd-442ac7122d43" = {
        credentialsFile = "/home/levinhne/.cloudflared/b88c50c9-86ee-4d6d-b4cd-442ac7122d43.json";
        default = "http_status:404";
        ingress = {
          "vinhtest.levinh.io.vn" = "http://127.0.0.1:8000";
        };
      };
    };
  };
}
