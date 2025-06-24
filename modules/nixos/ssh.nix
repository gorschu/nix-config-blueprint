{ options, config, lib, ...}:
let
  cfg = config.gorschu.services.ssh;
in
{
  options.gorschu.services.ssh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable and configure SSH";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 22;
      description = "SSH port to listen on";
    };
  };
  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [cfg.port];
      settings = {
        PermitRootLogin = "without-password";
      };
    };

    # ensure SSH hostkeys are secure
    systemd.tmpfiles.rules = [
      "z /etc/ssh/ssh* 0600 root root - -"
    ];
  };
}

