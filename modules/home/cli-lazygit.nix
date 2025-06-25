{
  config,
  lib,
  ...
}:
let
  cfg = config.gorschu.home.cli.lazygit;
in
{
  options.gorschu.home.cli.lazygit = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "install and configure lazygit";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.lazygit = {
      enable = true;
    };
    catppuccin.lazygit.enable = true;
  };
}
