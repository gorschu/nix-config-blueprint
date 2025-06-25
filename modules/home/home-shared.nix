{
  inputs,
  pkgs,
  lib,
  osConfig,
  ...
}:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    inputs.self.homeModules.cli
    inputs.self.homeModules.desktop
    inputs.self.homeModules.desktop-gnome # move this to desktop
    inputs.self.homeModules.general-session
  ];

  # only available on linux, disabled on macos
  services.ssh-agent.enable = pkgs.stdenv.isLinux;

  home.packages =
    [ pkgs.ripgrep ]
    ++ (
      # you can access the host configuration using osConfig.
      pkgs.lib.optionals (osConfig.programs.vim.enable && pkgs.stdenv.isDarwin) [ pkgs.skhd ]
    );

  home.stateVersion = "25.05"; # initial home-manager state
  gorschu.home.desktop.gnome.enable = true;

  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "macchiato";
      };
    };
    plugins.lualine.enable = true;
  };
  catppuccin = {
    flavor = "macchiato";
    accent = "rosewater";
  };
}
