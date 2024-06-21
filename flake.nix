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
    # nixpkgs-wayland = {
    #   url = "github:nix-community/nixpkgs-wayland";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
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
            "amd_pstate=passive"
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
            pkgs: with pkgs; [
              # linuxKernel.packages.linux_zen.v4l2loopback
              linuxKernel.packages.linux_zen.lenovo-legion-module
            ];
          extraModprobeConfig = ''
            blacklist sp5100_tco
            blacklist nouveau
            options nouveau modeset=0
          ''
          # ++ ''
          #   options v4l2loopback devices=1 video_nr=1 card_label="Virtual Camera" exclusive_caps=1
          # ''
          # ++ ''
          #   blacklist iTCO_wdt
          # ''
          ;
        };
        hardware.opengl.extraPackages =
          pkgs: with pkgs; [
            vaapiVdpau
            libGL
            libvdpau-va-gl
            mesa.drivers
            xorg.xf86videoamdgpu
          ];
        home.pointerCursor = {
          name = "Bibata-Modern-Classic";
          package = pkgs: pkgs.bibata-cursors;
          size = 24;
        };
        services.xserver.videoDrivers = [
          "modesetting"
          "fbdev"
          "amdgpu"
        ];
      };
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      inherit vars;
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
      overlays = import ./overlays { inherit inputs; };
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;
      nixosConfigurations = {
        "${vars.networking.hostName}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
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
                inherit inputs outputs;
              };
              modules = [ ./home-manager/home.nix ];
            };
      };
    };
}
