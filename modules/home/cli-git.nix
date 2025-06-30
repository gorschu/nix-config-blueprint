{
  config,
  options,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gorschu.home.cli.git;
in
{
  options.gorschu.home.cli.git = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "configure git for user";
    };
    userName = lib.mkOption {
      type = lib.types.str;
      description = "username for git configuration";
    };
    userEmail = lib.mkOption {
      type = lib.types.str;
      description = "email for git configuration";
    };
    signing = {
      format = lib.mkOption {
        type = lib.types.str;
        default = "openpgp";
        description = "signing key format";
      };
      key = lib.mkOption {
        type = lib.types.str;
        description = "gpg key id to use for signing commits";
      };
      signByDefault = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "sign everything by default";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      inherit (cfg) userName;
      inherit (cfg) userEmail;
      signing = {
        inherit (cfg.signing) format;
        inherit (cfg.signing) key;
        inherit (cfg.signing) signByDefault;
      };

      aliases = {
        dft = "difftool --tool difftastic";
        fixup = "!git log -n 50 --pretty=format:'%h %s' --no-merges | fzf | cut -c -7 | xargs -o git commit --fixup";
        sync = "!git switch main && git pull --prune && git branch --format '%(refname:short) %(upstream:track)' | awk '$2 == \"[gone]\" { print $1 }' | xargs -r git branch -D";
      };
      difftastic = {
        enable = true;
        enableAsDifftool = true;
        background = "dark";
      };
      lfs = {
        enable = true;
      };
      extraConfig = {
        color = {
          ui = "auto";
        };
        commit = {
          verbose = true;
        };
        core = {
          quotepath = false;
          pager = "${pkgs.bat}/bin/bat";
        };
        credential = {
          helper = "cache --timeout=3600";
        };
        feature = {
          manyFiles = true;
        };
        fetch = {
          prune = true;
        };
        github = {
          user = "gorschu";
        };
        help = {
          autocorrect = 20;
        };
        init = {
          defaultBranch = "main";
        };
        rerere = {
          enabled = true;
        };
        pager = {
          difftool = "${pkgs.bat}/bin/bat";
        };
        pull = {
          rebase = true;
        };
        push = {
          default = "simple";
          autoSetupRemote = true;
        };
        rebase = {
          autoSquash = true;
          autoStash = true;
          updateRefs = true;
        };
        submodule = {
          fetchjobs = 4;
          recurse = true;
        };
        tag = {
          forceSignAnnotated = true;
        };

      };
    };
  };
}
