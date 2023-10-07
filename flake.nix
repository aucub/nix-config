{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";

    systems.url = "github:nix-systems/default";

    nur.url = "github:nix-community/NUR";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    nur,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
  };
}
