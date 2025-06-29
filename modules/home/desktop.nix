{
  config,
  options,
  pkgs,
  lib,
  inputs,
  perSystem,
  ...
}:
let
  cfg = config.gorschu.home.desktop;
in
{
  imports = [
    inputs.self.homeModules.desktop-browser-firefox
    inputs.self.homeModules.desktop-browser-chrome
    inputs.self.homeModules.desktop-fonts
    inputs.self.homeModules.general-xdg
  ];

  options.gorschu.home.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable general desktop configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    gorschu.home.desktop.browser.firefox.enable = true;
    gorschu.home.desktop.browser.chrome.enable = true;
    gorschu.home.general.xdg.autostart.entries = [ "${pkgs.solaar}/share/applications/solaar.desktop" ];

    home.packages = [
      perSystem.self.vuescan
      pkgs.wl-clipboard
    ];

    gtk.enable = true;
  };
}
