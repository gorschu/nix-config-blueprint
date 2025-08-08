{
  inputs,
  options,
  config,
  lib,
  ...
}:
let
  cfg = config.gorschu.hardware.laptop;
in
{
  imports = [ inputs.auto-cpufreq.nixosModules.default ];
  options.gorschu.hardware.laptop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable and configure laptop options";
    };
    charger = {
      governor = lib.mkOption {
        type = lib.types.str; # could this be an enum?
        default = "performance";
        description = "Governor to use when charging";
      };
      turbo = lib.mkOption {
        type = lib.types.str; # could this be an enum?
        default = "auto";
        description = "How to use turbo mode when charging";
      };
    };
    battery = {
      governor = lib.mkOption {
        type = lib.types.str; # could this be an enum?
        default = "powersave";
        description = "Governor to use when on battery";
      };
      turbo = lib.mkOption {
        type = lib.types.str; # could this be an enum?
        default = "auto";
        description = "How to use turbo mode when on battery";
      };
      thresholds = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable and configure battery thresholds";
        };
        start = lib.mkOption {
          type = lib.types.int;
          default = 20;
          description = "Start charging at given threshold";
        };
        stop = lib.mkOption {
          type = lib.types.int;
          default = 90;
          description = "Stop charging at given threshold";
        };
      };
    };
  };
  config = lib.mkIf cfg.enable {
    programs.auto-cpufreq.enable = true;
    programs.auto-cpufreq.settings = {
      charger = {
        inherit (cfg.charger) governor;
        inherit (cfg.charger) turbo;
      };

      battery = {
        inherit (cfg.battery) governor;
        inherit (cfg.battery) turbo;
        enable_thresholds = cfg.battery.thresholds.enable;
        start_threshold = cfg.battery.thresholds.start;
        stop_threshold = cfg.battery.thresholds.stop;
      };
    };
  };
}
