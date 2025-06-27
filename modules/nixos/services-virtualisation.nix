{
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gorschu.services.virtualisation;
in
{
  options.gorschu.services.virtualisation = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable and configure virtualisation and container related things";
    };
    enablePodman = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable and configure podman";
    };
  };
  config = lib.mkIf cfg.enable {
  virtualisation.containers.enable = true;
  virtualisation.podman = lib.mkIf cfg.enablePodman {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };

  };
}
