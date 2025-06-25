{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gorschu.home.cli.bat;
in
{
  options.gorschu.home.cli.bat = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "install and configure bat";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batgrep
        batman
        batpipe
        batwatch
        batdiff
        prettybat
      ];
    };
    catppuccin.bat.enable = true;
  };
}
