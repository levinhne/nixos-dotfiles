{ config, pkgs, ... }:

{
  services.blocky = {
    enable = true;

    settings = {
      # Bootstrap DNS for initial list downloads
      bootstrapDns = [
        {
          upstream = "1.1.1.1";
          ips = [ "1.1.1.1" "1.0.0.1" ];
        }
      ];

      # Upstream DNS servers
      upstreams = {
        groups = {
          default = [
            # Cloudflare DNS
            "1.1.1.1"
            "1.0.0.1"
            # Google DNS
            "8.8.8.8"
            "8.8.4.4"
            # DNS over TLS
            "tcp-tls:1.1.1.1:853"
            # DNS over HTTPS
            "https://cloudflare-dns.com/dns-query"
          ];
        };
      };

      # Blocking configuration
      blocking = {
        denylists = {
          ads = [
            # StevenBlack's unified hosts file
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            # Additional ad blocking lists
            "https://adaway.org/hosts.txt"
            "https://v.firebog.net/hosts/AdguardDNS.txt"
            "https://v.firebog.net/hosts/Admiral.txt"
            "https://v.firebog.net/hosts/Easylist.txt"
            "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext"
          ];
          tracking = [
            "https://v.firebog.net/hosts/Easyprivacy.txt"
            "https://v.firebog.net/hosts/Prigent-Ads.txt"
          ];
          custom = [
            # Custom blocklist in config directory
            "file:///etc/nixos/config/blocky/custom-blocklist.txt"
          ];
        };

        clientGroupsBlock = {
          # Apply blocking to all clients
          default = [
            "ads"
            "tracking"
            "custom"
          ];
        };

        # Block type - return zero IP for blocked domains
        blockType = "zeroIp";
        blockTTL = "1m";

        # Loading strategy
        loading = {
          refreshPeriod = "4h";
          downloads = {
            timeout = "60s";
            attempts = 5;
            cooldown = "10s";
          };
        };
      };

      # Port configuration
      ports = {
        dns = 53;    # DNS port
        http = 4000; # HTTP API and metrics port
      };

      # Logging
      log = {
        level = "info";
        format = "text";
      };

      # Enable query logging to see what's being blocked
      queryLog = {
        type = "console";
        logRetentionDays = 7;
      };

      # Enable prometheus metrics (optional)
      prometheus = {
        enable = true;
        path = "/metrics";
      };

      # Caching
      caching = {
        minTime = "5m";
        maxTime = "30m";
        prefetching = true;
      };
    };
  };

  # Open firewall ports
  networking.firewall = {
    allowedTCPPorts = [ 53 4000 ];
    allowedUDPPorts = [ 53 ];
  };

  # Configure system to use Blocky as DNS server
  networking.nameservers = [ "127.0.0.1" ];
  
  # Prevent NetworkManager from overwriting DNS settings
  networking.networkmanager.dns = "none";
  
  # Create resolv.conf with Blocky as nameserver
  environment.etc."resolv.conf".text = ''
    nameserver 127.0.0.1
    options edns0 trust-ad
  '';

  # Copy custom blocklist to /etc/nixos/config/blocky/
  environment.etc."nixos/config/blocky/custom-blocklist.txt".source = 
    ../config/blocky/custom-blocklist.txt;
}
