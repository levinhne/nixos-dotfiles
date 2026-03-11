{ osConfig ? null, ... }:

let
  # Get username from system config if available
  userName = if osConfig != null then osConfig.mySystem.userName else "levinhne";
in
{
  # Git
  programs.git = {
    enable = true;
    settings = {
      credential.helper = "store";
      user.name = userName;
      user.email = "${userName}@example.com";  # TODO: Configure your actual email
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };
}
