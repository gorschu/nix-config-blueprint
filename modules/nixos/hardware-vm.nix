{
  options,
  config,
  lib,
  ...
}:
let
  cfg = config.gorschu.hardware.vm;
in
{
  options.gorschu.hardware.vm = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable and configure vm options";
    };
  };
  config = lib.mkIf cfg.enable {
    services.spice-vdagentd.enable = true;
    services.qemuGuest.enable = true;
  };
}
