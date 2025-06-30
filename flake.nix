{
  description = "Sharing home-manager modules between nixos and darwin";

  # Add all your dependencies here
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    blueprint.url = "github:numtide/blueprint";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    devshell.url = "github:numtide/devshell";
    sops-nix.url = "github:Mic92/sops-nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    # nixos-anywhere
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";

  };

  # Load the blueprint
  outputs = inputs: inputs.blueprint { inherit inputs; };
  nixpkgs.config.allowUnfree = true;
}
