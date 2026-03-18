# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let 
  secrets = import /etc/nixos/secrets.nix;
in 
{
  imports =
    [
      ./hardware-configuration.nix
      ./pi-hole.nix
      ./syncthing.nix 
      ./localization.nix
   ];


  # Host name
  networking.hostName = "nixos-server"; # Define your hostname.


  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  # Disable automatic updates
  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;


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


  # Disable X11
  services.xserver.enable = false;


  # User account
  users.users.${secrets.user1} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [
    ];
  };


  # System-wide packages
  # Find more on  https://search.nixos.org/
  environment.systemPackages = with pkgs; [
    tree
    wget
    neofetch
    git
    tldr
  ];

  # Cron
  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/3 * * * * root /etc/nixos/duckdns/script.sh" # Update dynamic IP DNS entry every 3 minutes
    ];
  };

  services.pihole-ftl = {
    enable = true;
    settings = {
      # See <https://docs.pi-hole.net/ftldns/configfile/>

      # External DNS Servers quad9 and cloudflare
      dns.upstreams = [ "9.9.9.9" "1.1.1.1" ];

      # Optionally resolve local hosts (domain is optional)
      dns.hosts = [ "192.168.1.188 hostname.domain" ];
    };
  };


  environment.etc = {
    "gitconfig".text = ''
      [user]
        name = ${secrets.gitUserName}
        email = ${secrets.gitUserEmail}  
    '';
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

