{
  inputs,
  options,
  config,
  lib,
  ...
}:
let
  cfg = config.gorschu.desktop;
in
{
  imports = [
    inputs.self.nixosModules.desktop-gnome
    inputs.self.nixosModules.services-cups
    inputs.self.nixosModules.services-pipewire
    inputs.self.nixosModules.hardware-bluetooth
    inputs.self.nixosModules.hardware-logitech
    inputs.self.nixosModules.desktop-programs-_1password
  ];
  options.gorschu.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable and configure desktop/graphical general settings";
    };
  };
  config = lib.mkIf cfg.enable {
    # enable solaar for Logitech devices
    gorschu.hardware.logitech = {
      enable = true;
      enableGraphical = true;
    };
    gorschu.programs._1password = {
      enable = true;
      gui.enable = true;
    };
    gorschu.services.pipewire.enable = true;
    gorschu.hardware.bluetooth.enable = true;
    services.power-profiles-daemon.enable = true;

    # see https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.portal.enable
    environment.pathsToLink = [
      "/share/xdg-desktop-portal"
      "/share/applications"
    ];
  };
}
