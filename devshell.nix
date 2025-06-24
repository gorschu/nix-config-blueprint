# devshell.nix
# Using mkShell from numtide/devshell
{ pkgs, perSystem, ... }:
perSystem.devshell.mkShell {

  imports = [
    # You might want to import other reusable modules
    (perSystem.devshell.importTOML ./devshell.toml)
  ];

#  env = [
#    # Add bin/ to the beginning of PATH
#    { name = "PATH"; prefix = "bin"; }
#  ];
#
#  # terraform will be present in the environment menu.
#  commands = [ { package = pkgs.terraform; } ];
}
