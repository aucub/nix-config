# Top-level flake glue to get our configuration working
{ inputs, ... }:

{
  imports = [
    inputs.nixos-unified.flakeModules.default
    inputs.nixos-unified.flakeModules.autoWire
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    {
      self',
      pkgs,
      system,
      ...
    }:
    {
      treefmt = {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
        settings.global.excludes = [
          "*.toml"
          "*.yml"
          "*.yaml"
          "*.json"
          "*.icc"
          "*.fish"
          "*.dae"
          "*.enc"
          "*.sh"
          ".envrc"
          "justfile"
        ];
      };

      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          (import ../../overlays {
            flake = {
              inherit inputs;
            };
          })
          inputs.nur.overlay
          inputs.nix-alien.overlays.default
          inputs.nix-vscode-extensions.overlays.default
        ];
        config.allowUnfree = true;
      };

      legacyPackages = pkgs;
    };
}
