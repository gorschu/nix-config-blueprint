{
  options,
  config,
  lib,
  ...
}:
let
  cfg = config.gorschu.zfs;
in
{
  options.gorschu.zfs = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable and configure ZFS options";
    };
  };
  config = lib.mkIf cfg.enable {
    services.zrepl = {
      enable = true;
      settings = {
        jobs = [
          {
            name = "local-snapjob";
            type = "snap";
            filesystems = {
              "zroot/local<" = true;
              "zroot/local/nix" = false;
              "zroot/local/root" = false;
            };
            snapshotting = {
              type = "periodic";
              interval = "15m";
              prefix = "zrepl_";
            };
            pruning = {
              keep = [
                {
                  type = "grid";
                  grid = "1x3h(keep=all) | 48x1h | 14x1d";
                  regex = "^zrepl_.*";
                }
                {
                  type = "regex";
                  negate = true;
                  regex = "^zrepl_.*";
                }
              ];
            };
          }
          {
            name = "local-push";
            type = "push";
            connect = {
              type = "local";
              listener_name = "local-sink";
              client_identity = config.networking.hostName;
            };
            filesystems = {
              "zroot/local<" = true;
              "zroot/local/nix" = false;
              "zroot/local/root" = false;
            };
            send = {
              encrypted = true;
            };
            replication = {
              protection = {
                initial = "guarantee_resumability";
                incremental = "guarantee_incremental";
              };
            };
            snapshotting = {
              type = "manual";
            };
            pruning = {
              keep_sender = [
                {
                  type = "regex";
                  regex = ".*";
                }
              ];
              keep_receiver = [
                {
                  type = "grid";
                  grid = " 1x1h(keep=all) | 24x1h | 360x1d";
                  regex = "^zrepl_.*";
                }
                {
                  type = "regex";
                  negate = true;
                  regex = "^zrepl_.*";
                }
              ];
            };
          }
          {
            name = "local-sink";
            type = "sink";
            root_fs = "backuppool/zrepl/sink";
            serve = {
              type = "local";
              listener_name = "local-sink";
            };
          }
        ];
      };
    };
  };
}
