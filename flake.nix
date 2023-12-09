{
  description = "nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-23.11";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    nur.url = "github:nix-community/NUR";
    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.follows = "nix-vscode-extensions/flake-utils";

    nix-alien.url = "github:thiagokokada/nix-alien";

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";

    stylix.url = "github:danth/stylix";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    flake-utils,
    home-manager,
    nix-index-database,
    nur,
    nix-alien,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    vars = {
      username = "your-username";
      hostname = "your-hostname";
      password = "correcthorsebatterystaple";
    };
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages =
      forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter =
      forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # FIXME replace with your hostname
      "${vars.hostname}" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs vars outputs;};
        modules = [
          # > Our main nixos configuration file <
          ./nixos/configuration.nix
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # FIXME replace with your username@hostname
      "${vars.username}@${vars.hostname}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs vars outputs;};
        modules = [
          # > Our main home-manager configuration file <
          ./home-manager/home.nix
        ];
      };
    };
  };
}
