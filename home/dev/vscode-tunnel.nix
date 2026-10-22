{ config, lib, pkgs, hostname, ... }:

{
  # VS Code Remote Tunnel, declared here instead of `code tunnel service install`
  # so ExecStart follows the current vscode store path (the generated unit
  # hardcodes it and breaks after an update + garbage collect).
  # Only on the work laptop: the tunnel login lives in ~/.vscode/cli per machine.
  systemd.user.services.code-tunnel = lib.mkIf (hostname == "nixos-vinhlq21") {
    Unit = {
      Description = "Visual Studio Code Tunnel";
      After = [ "network-online.target" ];
      StartLimitIntervalSec = 0;
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.vscode}/lib/vscode/bin/code-tunnel --verbose"
        + " --cli-data-dir ${config.home.homeDirectory}/.vscode/cli"
        + " tunnel service internal-run";
      Restart = "always";
      RestartSec = 10;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
