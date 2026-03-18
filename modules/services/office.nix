{ config, lib, pkgs, ... }:

let
  isOfficeHost = config.networking.hostName == "nixos-vinhlq21";

  # Default proxy settings for office
  defaultHttpProxy = "http://10.36.255.25:8080";
  defaultNoProxy = "127.0.0.1,localhost,10.0.0.0/8,192.168.0.0/16";

  certFile = "/etc/ssl/certs/ca-certificates.crt";

in
{
  config = lib.mkIf isOfficeHost {
    # Proxy configuration
    networking.proxy = {
      default = defaultHttpProxy;
      noProxy = defaultNoProxy;
    };

    # Office CA certificate
    # TODO: Move to agenix secrets and use proper certificate management
    security.pki.certificateFiles = [
      /etc/ssl/certs/office-ca.pem
    ];

  };
}
