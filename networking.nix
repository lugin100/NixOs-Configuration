{ config, lib, ... }:

let 
  secrets = import /etc/nixos/secrets.nix;
in 
{

  # Network connection
  networking.networkmanager.enable = true;

   # SSH
  services.openssh = {
    enable = true;
    ports = [ secrets.sshPort ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ secrets.user1 ];
      };
  };

  # Fail2Ban
  services.fail2ban.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}
  
