{
  options,
  config,
  lib,
  ...
}:
let
  cfg = config.gorschu.hardware.powermanagement;
in
{
  options.gorschu.hardware.powermanagement = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable and configure powermanagement configuration";
    };
    powertop = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "enable and configure powertop";
    };
  };
  config = lib.mkIf cfg.enable {
    powerManagement = {
      enable = true;
      powertop.enable = true;
    };
  };
}
