{ config, pkgs, lib, ... }:

{
  options = {
    mySystem.userName = lib.mkOption {
      type = lib.types.str;
      default = "levinhne";
      description = "Primary user name";
    };

    mySystem.userDescription = lib.mkOption {
      type = lib.types.str;
      default = "Le Vinh Ne";
      description = "User full name";
    };
  };

  config = {
    users.users.${config.mySystem.userName} = {
      isNormalUser = true;
      description = config.mySystem.userDescription;
      extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
      shell = pkgs.bash;
    };
  };
}
