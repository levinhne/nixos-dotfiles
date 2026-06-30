{ config, lib, ... }:

{
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = "--write-kubeconfig-mode 644";
  };

  networking.firewall = {
    allowedTCPPorts = [ 6443 ];
    allowedUDPPorts = [ 8472 ];
  };

  home-manager.users.${config.mySystem.userName} = { lib, ... }: {
    home.activation.k3sKubeconfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD mkdir -p $HOME/.kube
      $DRY_RUN_CMD ln -sf /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
    '';
  };
}
