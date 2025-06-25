{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gorschu.home.desktop.fonts;
in
{
  options.gorschu.home.desktop.fonts = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "install fonts";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
  };

}
