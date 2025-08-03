{
  inputs,
  options,
  config,
  lib,
  ...
}:
let
  cfg = config.gorschu.services.comin;
in
{
  imports = [ inputs.comin.nixosModules.comin ];
  options.gorschu.services.comin = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable and configure comin";
    };
    remote = lib.mkOption {
      type = lib.types.str;
      default = "https://github.com/gorschu/nix-config-blueprint";
      description = "remote to pull";
    };
    mainBranch = lib.mkOption {
      type = lib.types.str;
      default = "main";
      description = "main branch name";
    };
  };
  config = lib.mkIf cfg.enable {
    services.comin = {
      enable = true;
      remotes = [
        {
          name = "origin";
          url = cfg.remote;
          branches.main.name = cfg.mainBranch;
        }
      ];
    };
  };
}
