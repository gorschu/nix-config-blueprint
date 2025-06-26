{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gorschu.home.cli.eza;
in
{
  options.gorschu.home.cli.eza = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "install and configure eza";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      colors = "auto";
      icons = "auto";
      git = true;
    };
    # this is kind-of-hacky, but for now it works until a vivid module lands in hm
    home.sessionVariables = {
      LS_COLORS = "$(${pkgs.vivid}/bin/vivid generate catppuccin-macchiato)";
    };
  };
}
