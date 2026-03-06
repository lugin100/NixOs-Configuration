{ config, lib, ... }:

let
  secrets = import /etc/nixos/secrets.nix;
in
{
  services = {
    syncthing = {
      enable = true;
      group = "syncthing";
      user = secrets.user1;
      settings.gui = {
        user = secrets.syncthing.gui.user;
        password = secrets.syncthing.gui.password;
      };
      dataDir = secrets.syncthing.dataDir;
      configDir = secrets.syncthing.configDir;
      guiAddress = secrets.syncthing.gui.address;
      overrideDevices = true;     # overrides any devices added or deleted through the WebUI
      overrideFolders = true;     # overrides any folders added or deleted through the WebUI
      settings = {
        devices = {
          "kiesel-laptop" = { id = secrets.syncthing.id.kiesel-laptop; };
        };
        folders = {
          "Documents" = {
            path = secrets.syncthing.dataDir;
            devices = [ "kiesel-laptop" ];
          };
        };
      };
    };
  };
}
