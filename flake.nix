# flake.nix
{
  description = "Chimanta: AI workspace with alacritty, tmux, claude code and kukenan";
  # every file in ./modules is a flake-parts module (dendritic pattern)
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
    kukenan = {
      url = "github:juanalbarran/kukenan";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
