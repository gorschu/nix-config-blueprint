{
  config,
  options,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.gorschu.home.cli.gpg;
  fetchKey =
    {
      url,
      sha256 ? lib.fakeSha256,
    }:
    builtins.fetchurl { inherit sha256 url; };
in
{
  options.gorschu.home.cli.gpg = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "configure gpg for user";
    };
    publicKey = {
      url = lib.mkOption {
        type = lib.types.str;
        description = "url to fetch public key from";
      };
      sha256 = lib.mkOption {
        type = lib.types.str;
        description = "sha256 of public key";
      };
      trust = lib.mkOption {
        type = lib.types.int;
        description = "trustlevel of key";
        default = 5;
      };
    };
    agent = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "enable gpg-agent";
      };
      maxCacheTtl = lib.mkOption {
        type = lib.types.int;
        default = 7200;
        description = "expire cache after this time";
      };
      pinentry = lib.mkOption {
        type = lib.types.package;
        default = pkgs.pinentry-gnome3;
        description = "pinentry pkg to use";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      settings = {
        trust-model = "tofu+pgp";
      };
      publicKeys = [
        {
          source = fetchKey {
            inherit (cfg.publicKey) url;
            inherit (cfg.publicKey) sha256;
          };
          inherit (cfg.publicKey) trust;
        }
      ];
    };
    services.gpg-agent = lib.mkIf cfg.agent.enable {
      enable = true;
      enableSshSupport = false;
      defaultCacheTtl = cfg.agent.maxCacheTtl;
      pinentry.package = cfg.agent.pinentry;
      enableExtraSocket = true;
    };
    # ensure .gnupg is secure
    systemd.user.tmpfiles.rules =
      let
        inherit (config.home) username;
        inherit (config.home) homeDirectory;
      in
      [
        "z ${homeDirectory}/.gnupg 0700 ${username} ${username} - -"
      ];
  };
}

# TODO: write down the programs = let ... thing we did here so we don't forget before deleting
#{
#  pkgs,
#  config,
#  lib,
#  desktop,
#  user,
#  ...
#}: let
#  fetchKey = {
#    url,
#    sha256 ? lib.fakeSha256,
#  }:
#    builtins.fetchurl {inherit sha256 url;};
#
#  pinentry =
#    if desktop.environment == "plasma"
#    then {
#      package = pkgs.pinentry-qt;
#      name = "qt";
#    }
#    else if desktop.environment == "gnome"
#    then {
#      package = pkgs.pinentry-gnome3;
#      name = "pinentry-gnome3";
#    }
#    else {
#      package = pkgs.pinentry-curses;
#      name = "curses";
#    };
#in {
#  home.packages = [pinentry.package];
#
#  services.gpg-agent = {
#    enable = true;
#    enableSshSupport = false;
#    pinentryPackage = pinentry.package;
#    enableExtraSocket = true;
#  };
#
#  programs = let
#    fixGpg = ''
#      gpgconf --launch gpg-agent
#    '';
#  in {
#    # Start gpg-agent if it's not running or tunneled in
#    # SSH does not start it automatically, so this is needed to avoid having to use a gpg command at startup
#    # https://www.gnupg.org/faq/whats-new-in-2.1.html#autostart
#    bash.profileExtra = fixGpg;
#    #      fish.loginShellInit = fixGpg;
#    zsh.loginExtra = fixGpg;
#
#    gpg = {
#      enable = true;
#      settings = {
#        trust-model = "tofu+pgp";
#      };
#      publicKeys = [
#        {
#          source = fetchKey {
#            url = "https://github.com/azmodude.gpg";
#            sha256 = "sha256:1s9y4k90hjl7k75is6lyp491hg1my3vm1kxxahyslj5wy7w09pi8";
#          };
#          trust = 5;
#        }
#      ];
#    };
#  };
#  home.persistence = {
#    "/persist/home/${user.name}" = {
#      directories = [".gnupg"];
#    };
#  };
#
#  # ensure .gnupg is secure
#  systemd.user.tmpfiles.rules = [
#    "z /home/${user.name}/.gnupg 0700 ${user.name} ${user.name} - -"
#  ];
#
#
#  # Link /run/user/$UID/gnupg to ~/.gnupg-sockets
#  # So that SSH config does not have to know the UID
#  systemd.user.services.link-gnupg-sockets = {
#    Unit = {
#      Description = "link gnupg sockets from /run to /home";
#    };
#    Service = {
#      Type = "oneshot";
#      ExecStart = "${pkgs.coreutils}/bin/ln -Tfs /run/user/%U/gnupg %h/.gnupg-sockets";
#      ExecStop = "${pkgs.coreutils}/bin/rm $HOME/.gnupg-sockets";
#      RemainAfterExit = true;
#    };
#    Install.WantedBy = [ "default.target" ];
#  };
#}
# vim: filetype=nix
