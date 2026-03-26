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

    mySystem.gitEmail = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Git email address for the primary user.";
    };
  };

  config = {
    programs.fish.enable = true;
    programs.zsh.enable = true;

    environment.shells = with pkgs; [
      bashInteractive
      fish
      zsh
    ];

    users.users.${config.mySystem.userName} = {
      isNormalUser = true;
      description = config.mySystem.userDescription;
      extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
      shell = pkgs.fish;
    };
  };
}
