{
  options,
  config,
  lib,
  ...
}:
let
  cfg = config.gorschu.hardware.logitech;
in
{
  options.gorschu.hardware.logitech = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable and configure settings for logitech devices";
    };
    enableGraphical = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable graphical configuration (solaar)";
    };
  };
  config = lib.mkIf cfg.enable {
    # enable solaar for Logitech devices
    hardware.logitech.wireless = {
      enable = true;
      inherit (cfg) enableGraphical;
    };
  };
}
