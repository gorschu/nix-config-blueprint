{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.gorschu.system.boot;
in
{
  imports = [ inputs.self.nixosModules.system-boot-systemd-boot ];

  options.gorschu.system.boot = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable and configure boot configuration";
    };
    kernel = lib.mkOption {
      type = lib.types.raw;
      default = pkgs.linuxPackages_6_15;
      description = "use given kernel";
    };
    loader = lib.mkOption {
      type = lib.types.str; # probably make this an enum
      default = "systemd-boot";
      description = "use systemd-boot";
    };
  };
  config = lib.mkIf cfg.enable {
    #  boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelPackages = cfg.kernel;
    gorschu.system.boot.systemd-boot.enable = true;
  };

}
