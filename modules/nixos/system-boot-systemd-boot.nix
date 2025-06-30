{
  options,
  config,
  lib,
  ...
}:
let
  cfg = config.gorschu.system.boot.systemd-boot;
in
{
  options.gorschu.system.boot.systemd-boot = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable and configure systemd-boot";
    };
  };
  config = lib.mkIf cfg.enable {
    boot.loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };

  };
}
