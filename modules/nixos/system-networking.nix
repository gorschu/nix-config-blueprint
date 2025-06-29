{
  flake,
  options,
  config,
  lib,
  ...
}:
let
  cfg = config.gorschu.system.networking;
in
{
  options.gorschu.system.networking = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable and configure networking";
    };
    hostname = lib.mkOption {
      type = lib.types.str;
      description = "set hostname";
    };
    dns = lib.mkOption {
      type = lib.types.str;
      default = "systemd-resolved";
      description = "which dns backened to use";
    };
    networkmanager = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "enable and configure networkmanager";
      };
      wifi = {
        backend = lib.mkOption {
          type = lib.types.str;
          default = "wpa_supplicant";
          description = "which wifi backened to use";
        };
        powersave = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "enable wifi powersaving";
        };
      };
    };
  };
  config = lib.mkIf cfg.enable {
    sops.secrets."wifi.env" = {
      sopsFile = flake + /secrets/wifi.yaml;
    };
    networking = {
      hostName = cfg.hostname;
      hostId = builtins.substring 0 8 (builtins.hashString "sha256" config.networking.hostName);
      networkmanager = lib.mkIf cfg.networkmanager.enable {
        inherit (cfg) dns;
        wifi = {
          inherit (cfg.networkmanager.wifi) backend;
          inherit (cfg.networkmanager.wifi) powersave;
        };
        ensureProfiles = {
          environmentFiles = [ config.sops.secrets."wifi.env".path ];
          profiles = {
            home = {
              connection = {
                id = "home";
                type = "wifi";
              };
              wifi = {
                mode = "infrastructure";
                ssid = "$HOME_SSID";
              };
              wifi-security = {
                auth-alg = "open";
                key-mgmt = "wpa-psk";
                psk = "$HOME_PSK";
              };
            };
          };
        };
      };
    };
    systemd.network.wait-online.enable = false;
    services.resolved = {
      enable = cfg.dns == "systemd-resolved";
    };
  };
}
