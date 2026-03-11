{ config, pkgs, ... }:

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

  # Example: Declare secrets that will be decrypted at boot
  # Uncomment and customize as needed

  # age.secrets.office-cert = {
  #   file = ../secrets/office-cert.age;
  #   mode = "600";
  #   owner = config.mySystem.userName;
  #   group = "users";
  # };

  # Install agenix CLI for managing secrets
  environment.systemPackages = with pkgs; [
    # agenix CLI will be available from flake
  ];
}
