{ pkgs, options, config, lib, ...}:
let
  cfg = config.gorschu.programs._1password;
in
{
  options.gorschu.programs._1password = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable and configure 1Password";
    };
    gui = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable and configure 1Password GUI";
      };
      polkitPolicyOwners = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["gorschu"];
        description = "Polkit policy owners able to access 1Password GUI";
      };
      package = lib.mkOption {
    	type = lib.types.package;
	default = pkgs._1password-gui;
	description = "1Password gui package to use";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = cfg.gui.enable;
      polkitPolicyOwners = cfg.gui.polkitPolicyOwners;
      package = cfg.gui.package;
    };
  };
}

