{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/0b3416b40b3b6a467cae1d7ca40ec1d57a85d774";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-unified.url = "github:srid/nixos-unified";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niqspkgs = {
      url = "github:diniamo/niqspkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      imports =
        with builtins;
        map (fn: ./modules/flake-parts/${fn}) (attrNames (readDir ./modules/flake-parts));
    };

  # nixConfig = {
  #   experimental-features = [
  #     "nix-command"
  #     "flakes"
  #     "cgroups"
  #     "ca-derivations"
  #     "git-hashing"
  #     "dynamic-derivations"
  #   ];
  #   use-cgroups = true;
  #   use-registries = false;
  #   warn-dirty = false;
  #   fsync-metadata = false;
  #   always-allow-substitutes = true;
  #   builders-use-substitutes = true;
  #   require-sigs = false;
  #   extra-substituters = [
  #     "https://mirrors.ustc.edu.cn/nix-channels/store"
  #     "https://nix-community.cachix.org"
  #     "https://cache.garnix.io"
  #     "https://nanari.cachix.org"
  #   ];
  #   extra-trusted-public-keys = [
  #     "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  #     "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
  #     "nanari.cachix.org-1:g2X+SmJHsI0siZez0IUUgVyOuvPG5CWhrhoE11MqALA="
  #   ];
  # };
}
