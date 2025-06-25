{
  flake,
  inputs,
  pkgs,
  ...
}:
let
  treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs {
    projectRootFile = "flake.nix";

    programs.deadnix.enable = true;
    programs.nixfmt.enable = true;
    programs.statix.enable = true;
    programs.yamlfmt.enable = true;
    # ... other treefmt-nix config
    settings.formatter.yamlfmt.excludes = [
      "secrets/**/*.yaml"
      "secrets/*.yaml"
    ];
  };
  formatter = treefmtEval.config.build.wrapper;
in
formatter
// {
  passthru = formatter.passthru // {
    tests = {
      check = treefmtEval.config.build.check flake;
    };
  };
}
