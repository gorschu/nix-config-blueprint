{
  options,
  config,
  lib,
  ...
}:
let
  cfg = config.gorschu.services.pipewire;
in
{
  options.gorschu.services.pipewire = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable and configure PipeWire";
    };
  };
  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
