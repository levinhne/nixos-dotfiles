{ config, lib, pkgs, ... }:

let
  # Primary toggle: OFFICE_MODE
  officeMode = builtins.getEnv "OFFICE_MODE" != "";
  
  # Read proxy settings (with defaults)
  httpProxy = builtins.getEnv "HTTP_PROXY";
  httpsProxy = builtins.getEnv "HTTPS_PROXY";
  noProxy = builtins.getEnv "NO_PROXY";
  
  # Default proxy settings for office
  defaultHttpProxy = "http://10.36.255.25:8080";
  defaultNoProxy = "127.0.0.1,localhost,10.0.0.0/8,192.168.0.0/16";
  
  # Certificate path
  certPath = ../hosts/nixos-levinhne/certs/office.pem;
in
{
  config = lib.mkIf officeMode {
    # Proxy configuration
    networking.proxy = {
      default = if httpProxy != "" then httpProxy else defaultHttpProxy;
      noProxy = if noProxy != "" then noProxy else defaultNoProxy;
    };

    # SSL Certificate (chỉ load nếu file tồn tại)
    security.pki.certificateFiles = lib.mkIf (builtins.pathExists certPath) [
      certPath
    ];

    environment.variables = lib.mkIf (builtins.pathExists certPath) {
      SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    };
  };
}
