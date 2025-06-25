{
  config,
  lib,
  ...
}:
let
  cfg = config.gorschu.home.cli.shells;
in
{
  options.gorschu.home.cli.shells = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "install and configure shells";
    };
    bash = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "install and configure bash";
      };
    };
    zsh = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "install and configure zsh";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.bash = {
      inherit (cfg.bash) enable;
      enableVteIntegration = true;
    };
    programs.zsh = {
      inherit (cfg.zsh) enable;
    };
  };
}
