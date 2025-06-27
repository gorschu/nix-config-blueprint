{
  config,
  options,
  pkgs,
  lib,
  osConfig,
  inputs,
  ...
}:
let
  cfg = config.gorschu.home.desktop.gnome;
in
{
  imports = [ inputs.self.homeModules.desktop-terminal-ptyxis ];
  options.gorschu.home.desktop.gnome = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = osConfig.gorschu.desktop.gnome.enable;
      description = "configure dconf settings for Gnome";
    };
  };

  config = lib.mkIf cfg.enable {
    gorschu.home.desktop.terminal.ptyxis.enable = true;

    home.packages = with pkgs; [
      gnome-tweaks
      gnomeExtensions.pano
      gnomeExtensions.caffeine
      gnomeExtensions.tailscale-qs
      gnomeExtensions.gsconnect
      gnomeExtensions.appindicator
      gnomeExtensions.dash-to-dock
      gnomeExtensions.impatience
    ];

    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          pano.extensionUuid
          caffeine.extensionUuid
          tailscale-qs.extensionUuid
          gsconnect.extensionUuid
          appindicator.extensionUuid
          dash-to-dock.extensionUuid
          impatience.extensionUuid
        ];
        favorite-apps = [ "firefox.desktop" ];
      };

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
      "org/gnome/desktop/calendar" = {
        show-weekdate = true;
      };
      "org/gnome/system/location" = {
        enabled = true;
      };
      "org/gnome/tweaks" = {
        show-extensions-notice = false;
      };
      "org/gnome/shell/extensions/dash-to-dock" = {
        apply-custom-theme = true;
        background-opacity = 0.8;
        dash-max-icon-size = 48;
        dock-position = "BOTTOM";
        height-fraction = 0.9;
        hot-keys = true;
        preferred-monitor = -2;
        preferred-monitor-by-connector = "DP-1";
        show-apps-always-in-the-edge = true;
        show-show-apps-button = false;
      };
      "org/gnome/shell/extensions/pano" = {
        history-length = 30;
        play-audio-on-copy = false;
        send-notification-on-copy = false;
      };
    };
  };
}
