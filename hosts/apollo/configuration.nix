{
  flake,
  inputs,
  config,
  ...
}:
{

  imports = [
    inputs.self.nixosModules.host-shared
    inputs.self.nixosModules.services-pipewire
    inputs.self.nixosModules.hardware-bluetooth
    inputs.disko.nixosModules.disko
    inputs.nixos-facter-modules.nixosModules.facter
    ./disko.nix
  ];

  disko.devices.disk.main.device = "/dev/sda"; # change to /dev/disk/by-id/...
  facter.reportPath = ./facter.json;
  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = true;
  nix.extraOptions = ''
    experimental-features = nix-command flakes cgroups
  '';

  networking = {
    hostName = "apollo";
    hostId = builtins.substring 0 8 (builtins.hashString "sha256" config.networking.hostName);
  };
  systemd.network.wait-online.enable = false;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = "25.05";

  # flake references our flake root
  sops.secrets."root/password" = {
    sopsFile = flake + /secrets/hosts/${config.networking.hostName}/users.yaml;
    neededForUsers = true;
  };
  sops.secrets."gorschu/password" = {
    sopsFile = flake + /secrets/hosts/${config.networking.hostName}/users.yaml;
    neededForUsers = true;
  };

  users.groups.gorschu = {
    gid = 1000;
  };
  users.users = {
    gorschu = {
      uid = 1000;
      group = "gorschu";
      isNormalUser = true;
      createHome = true;
      homeMode = "0700";
      hashedPasswordFile = config.sops.secrets."gorschu/password".path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMUkEk7GV/qWMR9SJFYSJSxwnPxR8fG2Fn9VILHcyPYQ"
      ];
      extraGroups = [
        "wheel"
        "users"
      ];
    };
    root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKHpVzgsHl+TsjfyfAdRKpF55Q658/M3RBj03HzMdAaa"
      ];
      hashedPasswordFile = config.sops.secrets."root/password".path;
    };
  };
  users.mutableUsers = false;

  services.power-profiles-daemon.enable = true;
  services.automatic-timezoned.enable = true;

  gorschu.services.ssh.enable = true;
  gorschu.desktop = {
    enable = true;
    gnome.enable = true;
  };
  gorschu.programs._1password = {
    enable = true;
    gui.enable = true;
  };
  gorschu.services.pipewire.enable = true;
  gorschu.hardware.bluetooth.enable = true;
  gorschu.system.boot.systemd-boot.enable = true;

  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  programs.git.enable = true;
}
