let
  # User SSH keys (cho developer)
  levinhne = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJDpYkROoGtsZVYiPmNTJVrRMColvfcNR8maWyLXYMK levinh.dev@gmail.com";
  # Host SSH keys (cho mỗi máy NixOS)
  nixos-levinhne = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINZ1XzPrH0QGg1OKV5xGnQUJg1rNEAWbkIw9YTrc5tzd root@nixos-levinhne";

  nixos-office-levinhne = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILXVblo5A8i7cWwSv79VZla7IYIDRTBXevCSrLHI+3/R root@nixos-levinhne";
  # Groups để dễ quản lý
  allUsers = [ levinhne ];
  allHosts = [ nixos-levinhne ];
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
