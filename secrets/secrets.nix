let
  keys = import ./keys.nix;
  inherit (keys.users) levinhne vinhlq1;
  inherit (keys.hosts) nixos-levinhne nixos-vinhlq21;

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

  # API keys
  "fpt-api-key.age".publicKeys = allKeys;

  # Host-specific secrets (chỉ cho 1 máy)
}
