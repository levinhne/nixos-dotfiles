{ ... }:

{
  # Office network: HTTP proxy + corporate CA
  networking.proxy = {
    default = "http://10.36.255.25:8080";
    noProxy = "127.0.0.1,localhost,10.0.0.0/8,192.168.0.0/16";
  };

  # Absolute path outside the flake -> host này cần eval với --impure.
  # TODO: commit cert vào repo (cert công khai, không phải key) để build pure.
  security.pki.certificateFiles = [
    /etc/ssl/certs/office-ca.pem
  ];
}
