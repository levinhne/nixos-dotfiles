{ ... }:

{
  # Git
  programs.git = {
    enable = true;
    settings = {
      user.name = "levinhne";
      user.email = "levinhne@example.com";
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };
}
