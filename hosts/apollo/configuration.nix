{
  flake,
  inputs,
  config,
  ...
}:
{

  imports = [
    inputs.self.nixosModules.host-shared # defines most configuration shared between hosts
    inputs.self.nixosModules.system-filesystem-zfs
    inputs.self.nixosModules.system-networking

    inputs.disko.nixosModules.disko
    ./disko.nix
    inputs.nixos-facter-modules.nixosModules.facter
  ];

  disko.devices.disk.main.device = "/dev/sda"; # change to /dev/disk/by-id/...

  facter.reportPath = ./facter.json;
  nixpkgs.hostPlatform = "x86_64-linux";

  gorschu.system.networking = {
    enable = true;
    hostname = "apollo";
  };

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

  gorschu.desktop = {
    enable = true;
    gnome.enable = true;
  };

  gorschu.system.filesystem.zfs.enable = true;
  gorschu.services.comin.enable = true;
  gorschu.services.cups.enable = true;
  gorschu.services.ssh.enable = true;
  gorschu.services.virtualisation.enable = true;

  hardware.graphics = {
    enable = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = "25.05";
}
