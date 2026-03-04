{ config, lib, pkgs, ... }:

let
  isOfficeHost = config.networking.hostName == "nixos-office-levinhne";

  # Default proxy settings for office
  defaultHttpProxy = "http://10.36.255.25:8080";
  defaultNoProxy = "127.0.0.1,localhost,10.0.0.0/8,192.168.0.0/16";

  # Certificate path per host (optional)
  certPaths = {
    nixos-levinhne = ../hosts/nixos-levinhne/certs/office.pem;
    nixos-office-levinhne = ../hosts/nixos-office-levinhne/certs/office.pem;
  };
  certPath = certPaths.${config.networking.hostName} or null;
in
{
  config = lib.mkIf isOfficeHost {
    # Proxy configuration
    networking.proxy = {
      default = defaultHttpProxy;
      noProxy = defaultNoProxy;
    };

    # SSL Certificate (chỉ load nếu file tồn tại)
    security.pki.certificateFiles = lib.mkIf (certPath != null && builtins.pathExists certPath) [
      certPath
    ];

    environment.variables = lib.mkIf (certPath != null && builtins.pathExists certPath) {
      SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    };
  };
}
