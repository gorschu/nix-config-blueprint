{
  config,
  lib,
  ...
}:
let
  cfg = config.gorschu.home.cli.ripgrep;
in
{
  options.gorschu.home.cli.ripgrep = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "install and configure ripgrep";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ripgrep = {
      enable = true;
    };
    programs.ripgrep-all = {
      enable = true;
    };
  };
}
