{ config, pkgs, inputs, ... }:

let
  userName = config.mySystem.userName;
  userHome = "/home/${userName}";
in
{
  # Configure age.identityPaths - where to find SSH keys for decryption
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
    "${userHome}/.ssh/id_ed25519"
  ];

  age.secrets.fpt-api-key = {
    file = ../../secrets/fpt-api-key.age;
    mode = "440";
    owner = userName;
    group = "users";
  };


  # Install agenix CLI for managing secrets
  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
