{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gorschu.home.cli.fzf;
in
{
  options.gorschu.home.cli.fzf = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "install and configure fzf";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d --hidden --follow --exclude .git --exclude node_modules";
      changeDirWidgetOptions = [ "--preview '${pkgs.eza}/bin/eza -T {}'" ];
      defaultCommand = "${pkgs.fd}/bin/fd --type f --type l --hidden --follow --exclude .git --exclude node_modules";
      defaultOptions = [
        "--height 50%"
        "--tmux bottom,50%"
        "--border top"
      ];
      fileWidgetCommand = "${pkgs.fd}/bin/fd --type f --type l --follow --exclude .git --exclude node_modules";
      fileWidgetOptions = [ "--preview '${pkgs.bat}/bin/bat -n --color=always {}'" ];
      tmux = {
        enableShellIntegration = true;
        shellIntegrationOptions = [ "-d 50%" ];
      };
    };
    catppuccin.fzf.enable = true;
  };
}
