{
  options,
  config,
  lib,
  ...
}:
let
  cfg = config.gorschu.desktop;
in
{
  options.gorschu.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable and configure desktop/graphical general settings";
    };
  };
  config = lib.mkIf cfg.enable {
    # enable solaar for Logitech devices
    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };
}
