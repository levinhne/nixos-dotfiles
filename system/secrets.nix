{ config, pkgs, ... }:

{
  # Configure age.identityPaths - where to find SSH keys for decryption
  age.identityPaths = [ 
    "/etc/ssh/ssh_host_ed25519_key"
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

age.secrets.my-secret = {
  file = ../secrets/my-secret.age;     # Path đến file .age
  path = "/run/agenix/my-secret";      # Nơi file được decrypt
  mode = "600";                         # Permissions
  owner = "levinhne";                   # Owner
  group = "users";                      # Group
};

age.secrets.crush-openai = {
  file = ../secrets/crush-openai.age;
  path = "/run/agenix/crush-openai";
  mode = "600";
  owner = "levinhne";
  group = "users";
};

age.secrets.crush-fpt = {
  file = ../secrets/crush-fpt.age;
  path = "/run/agenix/crush-fpt";
  mode = "600";
  owner = "levinhne";
  group = "users";
};

  # Install agenix CLI for managing secrets
  environment.systemPackages = with pkgs; [
    # agenix CLI will be available from flake
  ];
}
