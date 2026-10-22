{ pkgs, ... }:

{
  # FPT Cloud Desktop client, repackaged from ppa:fptsmartcloud/ppa (packages/fcdclient.nix)
  environment.systemPackages = [ pkgs.fcdclient ];

  # Links from the FCD web portal (uds://, udss://, fcds://) open in the client
  xdg.mime.defaultApplications = {
    "x-scheme-handler/uds" = "fcdclient.desktop";
    "x-scheme-handler/udss" = "fcdclient.desktop";
    "x-scheme-handler/fcds" = "fcdclient.desktop";
  };
}
