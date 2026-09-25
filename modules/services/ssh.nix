{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
  programs.ssh.startAgent = true;
  # Lần đầu dùng key (ssh, git push, gopass sync) hỏi passphrase 1 lần rồi agent giữ luôn
  programs.ssh.extraConfig = ''
    AddKeysToAgent yes
  '';
}
