{ pkgs, inputs, ... }:
{
  imports = [
    inputs.self.nixosModules.desktop
    inputs.self.nixosModules.hardware-powermanagement
    inputs.self.nixosModules.services-ssh
    inputs.self.nixosModules.services-virtualisation
    inputs.self.nixosModules.system-locale
    inputs.catppuccin.nixosModules.catppuccin
    inputs.sops-nix.nixosModules.sops
  ];

  programs.vim.enable = true;

  # you can check if host is darwin by using pkgs.stdenv.isDarwin
  environment.systemPackages = [
    pkgs.btop
  ] ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [ pkgs.xbar ]);

  nixpkgs.config.allowUnfree = true;
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes cgroups
    '';
  };
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 3";
    flake = "/home/gorschu/nix-config";
  };
  catppuccin = {
    flavor = "macchiato";
    accent = "rosewater";
    tty = {
      enable = true;
    };
  };
  home-manager.backupFileExtension = "backup";
}
