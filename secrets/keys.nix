# SSH public keys dùng chung cho agenix (secrets.nix) và gopass (Makefile: gopass-recipients).
{
  users = {
    levinhne = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJDpYkROoGtsZVYiPmNTJVrRMColvfcNR8maWyLXYMK levinh.dev@gmail.com";
    vinhlq1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIANW+3CFZMvRZ0m2PokrfpweXsrDZfaS88b4mmgs5ThN vinhlq21@fpt.com";
  };

  hosts = {
    nixos-levinhne = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINZ1XzPrH0QGg1OKV5xGnQUJg1rNEAWbkIw9YTrc5tzd root@nixos-levinhne";
    nixos-vinhlq21 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILXVblo5A8i7cWwSv79VZla7IYIDRTBXevCSrLHI+3/R root@nixos-levinhne";
  };
}
