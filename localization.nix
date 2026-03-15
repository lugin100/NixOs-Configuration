{ config, lib, pkgs, ... }:

{
  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
 
  i18n.extraLocales = [ "de_DE.UTF-8/UTF-8" ];
 
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };
console = {
    font = "Lat2-Terminus16";
    keyMap = pkgs.lib.mkForce "de";
    useXkbConfig = true; # use xkb.options in tty.
  };
}
