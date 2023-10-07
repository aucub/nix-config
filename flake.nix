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
    eachSystem = f:
      nixpkgs.lib.genAttrs (import systems) (
        system:
          f nixpkgs.legacyPackages.${system}
      );
  in 
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
}
