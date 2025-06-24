{ options, config, lib, ...}:
let
  cfg = config.gorschu.desktop.kde;
in
{
  options.gorschu.desktop.kde = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable and configure KDE";
    };
  };
  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.displayManager.sddm = {
       enable = true;
       wayland.enable = true;
    };
    services.desktopManager.plasma6.enable = true;

#    qt = {
#     enable = true;
#     platformTheme = "gnome";
#     style = "adwaita-dark";
#   };
};
}

