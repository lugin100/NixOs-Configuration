{ config, lib, ... }:

{
  config = lib.mkIf true {
    services.resolved = {
      enable = true;
      extraConfig = ''
        DNSStubListener=no
        MulticastDNS=off
      '';
    };
    services.pihole-ftl = {
      enable = true;
      openFirewallDNS = true;
      openFirewallWebserver = true;
      queryLogDeleter.enable = true;
      settings = {
        dns = {
          upstreams = [ "9.9.9.9" "1.1.1.1" ];
          listeningMode = "ALL";
          hosts = [ "192.168.1.188 hostname.domain" ];

        };
        dhcp = {
          active = false;
        };
      };
      lists = [
        {
          url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
          description = "StevenBlack Unified";
          type = "block";
          enabled = true;
        }
        {
          url = "https://big.oisd.nl";
          description = "OISD Big";
          type = "block";
          enabled = true;
        }
      ];
    };
    services.pihole-web = {
      enable = true;
      ports = [ "8000" ]; 
    };
    # The following silences a benign FTL.log warning:
    # WARNING API: Failed to read /etc/pihole/versions (key: internal_error)
    systemd.tmpfiles.rules = [
      "f /etc/pihole/versions 0644 pihole pihole - -"
    ];
  };
}

