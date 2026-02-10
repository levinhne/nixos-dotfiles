{ ... }:

{
  # Git
  programs.git = {
    enable = true;
    settings = {
      credential.helper = "store";
      user.name = "levinhne";
      user.email = "levinhne@example.com";
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };
}
