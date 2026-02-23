let
  # User SSH keys (cho developer)
  levinhne = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJDpYkROoGtsZVYiPmNTJVrRMColvfcNR8maWyLXYMK levinh.dev@gmail.com";
  # Host SSH keys (cho mỗi máy NixOS)
  nixos-levinhne = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINZ1XzPrH0QGg1OKV5xGnQUJg1rNEAWbkIw9YTrc5tzd root@nixos-levinhne";
  # TODO: Thêm key cho nixos-office-levinhne khi có
  # nixos-office-levinhne = "ssh-ed25519 AAAA... root@nixos-office-levinhne";

  # Groups để dễ quản lý
  allUsers = [ levinhne ];
  allHosts = [ nixos-levinhne ];
  allKeys = allUsers ++ allHosts;
in
{
  "my-secret.age".publicKeys = allKeys;
  
  # Example: GitHub token
  # "github-token.age".publicKeys = allKeys;
  
  # Example: WiFi password
  # "wifi-password.age".publicKeys = allKeys;
  
  # Example: API keys
  # "api-keys.age".publicKeys = allKeys;
  
  # Host-specific secrets (chỉ cho 1 máy)
  "nixos-levinhne-secret.age".publicKeys = [ levinhne nixos-levinhne ];
}
