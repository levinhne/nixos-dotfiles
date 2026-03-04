{ config, pkgs, ... }:

{
  # Configure age.identityPaths - where to find SSH keys for decryption
  age.identityPaths = [ 
    "/home/levinhne/.ssh/id_ed25519"
  ];

  # Example: Declare secrets that will be decrypted at boot
  # Uncomment and customize as needed
  
  # age.secrets.ssh-key-example = {
  #   file = ../secrets/ssh-key-example.age;
  #   path = "/run/agenix/ssh-key-example";
  #   mode = "600";
  #   owner = "levinhne";
  #   group = "users";
  # };

  # age.secrets.github-token = {
  #   file = ../secrets/github-token.age;
  #   path = "/run/agenix/github-token";
  #   mode = "600";
  #   owner = "levinhne";
  # };

# age.secrets.crush-fpt = {
#   file = ../secrets/crush-fpt.age;
#   path = "/run/agenix/crush-fpt";
#   mode = "600";
#   owner = "levinhne";
#   group = "users";
# };

  # Install agenix CLI for managing secrets
  environment.systemPackages = with pkgs; [
    # agenix CLI will be available from flake
  ];
}
