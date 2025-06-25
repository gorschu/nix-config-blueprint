{
  config,
  lib,
  ...
}:
let
  cfg = config.gorschu.home.desktop.browser.chrome;
in
{
  options.gorschu.home.desktop.browser.chrome = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "install and configure chromium";
    };
    defaultBrowser = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "set chromium as default browser";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.google-chrome = {
      enable = true;
      commandLineArgs = [
        "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,Vulkan,VulkanFromANGLE,DefaultANGLEVulkan,VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport,UseMultiPlaneFormatForHardwareVideo"
      ];
    };
    home = lib.mkIf cfg.defaultBrowser {
      sessionVariables = {
        BROWSER = "chromium";
      };
      # persistence = {
      #   "/persist/home/${config.home.userName}" = {
      #     directories = [".config/chromium"];
      # };
    };
    xdg.mimeApps.defaultApplications = lib.mkIf cfg.defaultBrowser {
      "text/html" = [ "chromium.desktop" ];
      "text/xml" = [ "chromium.desktop" ];
      "x-scheme-handler/http" = [ "chromium.desktop" ];
      "x-scheme-handler/https" = [ "chromium.desktop" ];
    };

  };

}
