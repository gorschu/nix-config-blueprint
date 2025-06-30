{
  config,
  lib,
  ...
}:
let
  cfg = config.gorschu.home.general.xdg;
in
{
  options.gorschu.home.general.xdg = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "enable xdg configuration";
    };
    autostart = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "enable xdg autostart";
      };
      readOnly = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "make xdg autostart readonly";
      };
      entries = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "list of autostart entries";
      };
    };
    mimeApps = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "enable xdg mimeapps management";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    xdg = {
      enable = true;
      autostart = {
        inherit (cfg.autostart) enable;
        inherit (cfg.autostart) readOnly;
        inherit (cfg.autostart) entries;
      };
      mime = {
        enable = true;
      };
      mimeApps = {
        inherit (cfg.mimeApps) enable;
      };
      portal = {
        enable = true;
        config = {
          common = {
            default = [
              "gtk"
            ];
          };
          gnome = {
            default = [
              "gnome"
              "gtk"
            ];
          };
          hyprland = {
            default = [
              "hyprland"
              "gtk"
            ];
          };
        };
        xdgOpenUsePortal = true;
      };
      # mimeapps.list gets frequently clobbered, force overwrite
      configFile."mimeapps.list".force = true;
    };
  };
}
