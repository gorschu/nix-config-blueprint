{
  config,
  options,
  lib,
  ...
}:
let
  cfg = config.gorschu.home.desktop.terminal.ptyxis;
in
{
  options.gorschu.home.desktop.terminal.ptyxis = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "install and configure ptyxis terminal";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ptyxis = {
      enable = true;
    };

    dconf.settings = {
      "org/gnome/Ptyxis" = {
        default-profile-uuid = "cac2be90ce456a5d1fa860a8685bb29e";
        font-name = "JetBrainsMono Nerd Font 11";
        profile-uuids = [ "cac2be90ce456a5d1fa860a8685bb29e" ];
        use-system-font = false;
      };
    };
  };
}
