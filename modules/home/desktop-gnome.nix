{
  config,
  options,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  cfg = config.gorschu.home.desktop.gnome;
in
{
  options.gorschu.home.desktop.gnome = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = osConfig.gorschu.desktop.gnome.enable;
      description = "configure dconf settings for Gnome";
    };
  };

  config = lib.mkIf cfg.enable {
    dconf.settings = {
      "org/gnome/desktop/background" = {
        picture-uri = "file://${pkgs.gnome-backgrounds}/share/backgrounds/gnome/symbolic-soup-l.jxl";
        picture-uri-dark = "file://${pkgs.gnome-backgrounds}/share/backgrounds/gnome/symbolic-soup-d.jxl";
      };
      "org/gnome/desktop/input-sources" = {
        mru-sources = [
          (lib.hm.gvariant.mkTuple [
            "xkb"
            "us"
          ])
        ];
        sources = [
          (lib.hm.gvariant.mkTuple [
            "xkb"
            "de+nodeadkeys"
          ])
          (lib.hm.gvariant.mkTuple [
            "xkb"
            "us"
          ])
        ];
        xkb-options = [ "caps:escape" ];
      };
      "org/gnome/desktop/interface" = {
        accent-color = "teal";
        color-scheme = "prefer-dark";
        enable-hot-corners = false;
        show-battery-percentage = true;
        font-antialiasing = "rgba";
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        two-finger-scrolling-enabled = true;
      };

      "org/gnome/desktop/screensaver" = {
        lock-delay = lib.hm.gvariant.mkUint32 120;
        color-shading-type = "solid";
        picture-options = "zoom";
        picture-uri = "file://${pkgs.gnome-backgrounds}/share/backgrounds/gnome/symbolic-soup-l.jxl";
        primary-color = "#B9B5AE";
        secondary-color = "#000000";
      };
      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
        night-light-schedule-automatic = true;
        night-light-temperature = lib.hm.gvariant.mkUint32 3700;
      };
      "org/gnome/desktop/wm/preferences" = {
        action-middle-click-titlebar = "lower";
        resize-with-right-button = true;
      };
      "org/gnome/system/location" = {
        enabled = true;
      };
      "org/gnome/tweaks" = {
        show-extensions-notice = false;
      };
    };
    home.packages = with pkgs; [
      gnome-tweaks
    ];
    programs.ptyxis = {
      enable = true;
    };
  };
}
