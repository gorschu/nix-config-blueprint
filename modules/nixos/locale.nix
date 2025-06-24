{ options, config, lib, ...}:
let
  cfg = config.gorschu.locale;
in
{
  options.gorschu.locale = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable and configure locales";
    };
    default = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "set default locale";
    };
    extra_locale = lib.mkOption {
      type = lib.types.str;
      default = "de_DE.UTF-8";
      description = "set extra locale for various regional formats";
    };
    timezone = lib.mkOption {
      type = lib.types.str;
      default = "automatic";
      description = "set timezone";
    };
  };
  config = lib.mkIf cfg.enable {
    i18n = {
      defaultLocale = cfg.default;
      supportedLocales = ["${cfg.default}/UTF-8" "${cfg.extra_locale}/UTF-8"];
      extraLocaleSettings = {
        # LC_ALL = cfg.default
      LC_MESSAGES = cfg.default;
      LC_ADDRESS = cfg.extra_locale;
      LC_MEASUREMENT = cfg.extra_locale;
      LC_MONETARY = cfg.extra_locale;
      LC_NAME = cfg.extra_locale;
      LC_NUMERIC = cfg.extra_locale;
      LC_PAPER = cfg.extra_locale;
      LC_TELEPHONE = cfg.extra_locale;
      LC_TIME = cfg.extra_locale;
      LC_COLLATE = cfg.extra_locale;
      };
    };
    time = lib.mkIf (cfg.timezone != "automatic") {
      timeZone = cfg.timezone;
    };
    services.tzupdate = lib.mkIf (cfg.timezone == "automatic") {
      enable = true;
      timer = {
        enable = true;
        interval = "hourly";
      };
    };
  };
}

