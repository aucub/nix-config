{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      vars = {
        networking.hostName = "neko";
        users.users = {
          user = {
            username = "uymi";
            initialHashedPassword = "$y$j9T$XOU8eqbT/uiYRkLNMVma91$FpP9C3IIhl1t/i9LH0k5LxqwnRKH9baVotniFxx7vG4";
          };
          root.initialHashedPassword = "$y$j9T$/qg2DYP0TOSZzSwlgs9mV/$uVAqBwhXEnwkMd0D4zKH9SSBQ4WzlGcnimnLrbyNwP4";
        };
        boot = {
          kernelParams = [
            "amdgpu.vm_update_mode=3"
            "radeon.dpm=0"
            "acpi_backlight=native"
            "mitigations=off" # 关闭漏洞缓解措施提高性能
            "nowatchdog" # PC不需要watchdog
          ];
          kernelModules = [
            # "v4l2loopback"
            "amdgpu"
          ];
          extraModulePackages =
            kernelPackages: with kernelPackages; [
              # v4l2loopback
            ];
          extraModprobeConfig = ''
            blacklist sp5100_tco
            blacklist iTCO_wdt
            options nvidia "NVreg_EnableGpuFirmware=0"
          ''
          # ++ ''
          #   options v4l2loopback devices=1 video_nr=1 card_label="Virtual Camera" exclusive_caps=1
          # ''
          ;
        };
        home.pointerCursor = {
          name = "Bibata-Modern-Classic";
          package = pkgs: pkgs.bibata-cursors;
          size = 24;
        };
      };
    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
      overlays = import ./overlays { inherit inputs; };
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;
      nixosConfigurations = {
        "${vars.networking.hostName}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs vars outputs;
          };
          modules = [ ./nixos/configuration.nix ];
        };
      };
      homeConfigurations = {
        "${vars.users.users.user.username}@${vars.networking.hostName}" =
          home-manager.lib.homeManagerConfiguration
            {
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
              extraSpecialArgs = {
                inherit inputs vars outputs;
              };
              modules = [ ./home-manager/home.nix ];
            };
      };
    };
}
