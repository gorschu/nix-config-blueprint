{ options, config, lib, ...}:
let
  cfg = config.gorschu.hardware.bluetooth;
in
{
  options.gorschu.hardware.bluetooth = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable and configure bluetooth";
    };
  };
  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
	  Experimental = true;
        };
      };
    };
  };
}

