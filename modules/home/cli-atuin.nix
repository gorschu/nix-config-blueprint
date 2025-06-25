{
  config,
  lib,
  ...
}:
let
  cfg = config.gorschu.home.cli.atuin;
in
{
  options.gorschu.home.cli.atuin = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "install and configure atuin";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.atuin = {
      enable = true;
      daemon.enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    catppuccin.atuin.enable = true;
  };
}
