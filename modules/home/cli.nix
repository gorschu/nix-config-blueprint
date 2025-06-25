{
  inputs,
  ...
}:
{
  imports = [
    inputs.self.homeModules.cli-atuin
    inputs.self.homeModules.cli-bat
    inputs.self.homeModules.cli-git
    inputs.self.homeModules.cli-gpg
    inputs.self.homeModules.cli-lazygit
    inputs.self.homeModules.cli-ripgrep
    inputs.self.homeModules.cli-shells
  ];

}
