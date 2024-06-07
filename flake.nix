{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-unstable-small.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
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
    vars = {
      hostname = "neko";
      users.users = {
        username = "uymi";
        initialHashedPassword = "$y$j9T$XOU8eqbT/uiYRkLNMVma91$FpP9C3IIhl1t/i9LH0k5LxqwnRKH9baVotniFxx7vG4";
        root.initialHashedPassword = "$y$j9T$/qg2DYP0TOSZzSwlgs9mV/$uVAqBwhXEnwkMd0D4zKH9SSBQ4WzlGcnimnLrbyNwP4";
      };
      boot = {
        kernelParams = [
          "amd_pstate=passive"
          "amdgpu.vm_update_mode=3"
          "radeon.dpm=0"
          "acpi_backlight=native"
          "acpi=force"
          "pci=noacpi"
          "acpi_osi="
        ];
        kernelModules = [
          "v4l2loopback"
          "amdgpu"
        ];
        extraModulePackages = pkgs:
          with pkgs; [
            linuxKernel.packages.linux_zen.v4l2loopback
          ];
        extraModprobeConfig = ''
          options v4l2loopback exclusive_caps=1 video_nr=9 card_label="Virtual Camera"
        '';
      };
      hardware.opengl.extraPackages = pkgs:
        with pkgs; [
          amdvlk
          vaapiVdpau
          libGL
          libvdpau-va-gl
          mesa.drivers
          xorg.xf86videoamdgpu
        ];
    };
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    overlays = import ./overlays {inherit inputs;};
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;
    nixosConfigurations = {
      "${vars.hostname}" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs vars outputs;
        };
        modules = [
          ./nixos/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      "${vars.users.users.username}@${vars.hostname}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs vars outputs;
        };
        modules = [
          ./home-manager/home.nix
        ];
      };
    };
  };
}
