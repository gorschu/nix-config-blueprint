{
  inputs,
  ...
}:
{
  imports = [
    inputs.self.homeModules.cli-atuin
    inputs.self.homeModules.cli-bat
    inputs.self.homeModules.cli-eza
    inputs.self.homeModules.cli-fzf
    inputs.self.homeModules.cli-git
    inputs.self.homeModules.cli-gpg
    inputs.self.homeModules.cli-lazygit
    inputs.self.homeModules.cli-neovim
    inputs.self.homeModules.cli-ripgrep
    inputs.self.homeModules.cli-shells
    inputs.self.homeModules.cli-tmux
  ];

}
