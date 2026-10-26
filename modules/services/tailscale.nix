{ ... }:

{
  # SSH vào máy qua tailnet: ssh <user>@<hostname> (MagicDNS) hoặc IP 100.x
  # Lần đầu sau rebuild: `sudo tailscale up` rồi mở link login in ra
  services.tailscale = {
    enable = true;
    openFirewall = true; # UDP 41641 để kết nối P2P, không mở thì đi vòng qua DERP relay
  };
}
