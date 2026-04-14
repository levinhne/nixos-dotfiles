let
  levinhne = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJDpYkROoGtsZVYiPmNTJVrRMColvfcNR8maWyLXYMK levinh.dev@gmail.com";
  nixos-levinhne = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINZ1XzPrH0QGg1OKV5xGnQUJg1rNEAWbkIw9YTrc5tzd root@nixos-levinhne";

  vinhlq1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIANW+3CFZMvRZ0m2PokrfpweXsrDZfaS88b4mmgs5ThN vinhlq21@fpt.com";

  nixos-vinhlq21 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILXVblo5A8i7cWwSv79VZla7IYIDRTBXevCSrLHI+3/R root@nixos-levinhne";
  # Groups để dễ quản lý
  allUsers = [ levinhne vinhlq1 ];
  allHosts = [ nixos-levinhne nixos-vinhlq21 ];
  allKeys = allUsers ++ allHosts;
in
{

  # Example: GitHub token
  # "github-token.age".publicKeys = allKeys;

  # Example: WiFi password
  # "wifi-password.age".publicKeys = allKeys;

  # Example: API keys
  # "api-keys.age".publicKeys = allKeys;

  # Host-specific secrets (chỉ cho 1 máy)
}
