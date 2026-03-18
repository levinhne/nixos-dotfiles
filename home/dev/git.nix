{ lib, osConfig ? null, ... }:

let
  # Get username from system config if available
  userName = if osConfig != null then osConfig.mySystem.userName else "levinhne";
  gitEmail = if osConfig != null then osConfig.mySystem.gitEmail else "levinhne@nixos-btw";
in
{
  # Git
  programs.git = {
    enable = true;
    # Leave user.email unset by default until mySystem.gitEmail is provided explicitly.
    settings =
      {
        credential.helper = "store";
        user.name = userName;
        init.defaultBranch = "main";
        pull.rebase = false;
      }
      // lib.optionalAttrs (gitEmail != null) {
        user.email = gitEmail;
      };
  };
}
