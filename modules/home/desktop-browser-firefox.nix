{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gorschu.home.desktop.browser.firefox;
in
{
  options.gorschu.home.desktop.browser.firefox = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "install and configure firefox";
    };
    defaultBrowser = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "set firefox as default browser";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox.override {
        nativeMessagingHosts = [ pkgs.tridactyl-native ];
        cfg = {
          pipewire = true;
          ffmpeg = true;
          cups = true;
        };
      };
      profiles = {
        "default" = {
          id = 0;
          isDefault = true;
          # make sure we are using ffmpeg for video acceleration
          settings = {
            "media.ffmpeg.vaapi.enabled" = true;
          };
        };
        "work" = {
          id = 1;
          isDefault = false;
          # make sure we are using ffmpeg for video acceleration
          settings = {
            "media.ffmpeg.vaapi.enabled" = true;
          };
        };
      };
    };
    home = lib.mkIf cfg.defaultBrowser {
      sessionVariables = {
        MOZ_ENABLE_WAYLAND = 1;
        BROWSER = "firefox";
      };
      # persistence = {
      #   "/persist/home/${user.name}" = {
      #     directories = [".mozilla/firefox"];
      # };
    };
    xdg.mimeApps.defaultApplications = lib.mkIf cfg.defaultBrowser {
      "text/html" = [ "firefox.desktop" ];
      "text/xml" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
    };

  };

}
