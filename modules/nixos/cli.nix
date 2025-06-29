{
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gorschu.cli;
in
{
  options.gorschu.cli = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable and configure general cli settings/programs.";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sysstat
      psmisc
    ];
  };
}
