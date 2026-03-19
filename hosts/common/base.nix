{ ... }:

{
  imports = [
    ../../modules/system/boot.nix
    ../../modules/system/core.nix
    ../../modules/system/locale.nix
    ../../modules/system/nix.nix
    ../../modules/system/networking.nix
    ../../modules/system/security.nix
    ../../modules/system/user.nix
    ../../modules/system/secrets.nix
    ../../modules/services/ssh.nix
    ../../modules/services/office.nix
    ../../modules/dev/docker.nix
    ../../modules/dev/packages.nix
  ];
}
