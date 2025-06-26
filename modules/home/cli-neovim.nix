{
  config,
  lib,
  ...
}:
let
  cfg = config.gorschu.home.cli.neovim;
in
{
  options.gorschu.home.cli.neovim = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "install and configure neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavour = "${config.catppuccin.flavor}";
        };
      };
      plugins.lualine.enable = true;
    };
  };
}
