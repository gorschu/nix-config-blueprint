{
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gorschu.desktop.gnome;
in
{
  options.gorschu.desktop.gnome = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable and configure Gnome";
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      desktopManager.gnome.enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
    environment.gnome.excludePackages = with pkgs; [
      gnome-console
      evince
    ];
    services.udev.packages = [ pkgs.gnome-settings-daemon ];
  };
}
