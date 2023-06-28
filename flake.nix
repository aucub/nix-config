{
  description = "nix config";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org/"
    ];

    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    # 您可以同时访问不同nixpkgs版本的软件包和模块。这里是一个工作示例:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # 此外，请查看“overlays/default.nix”中的“unstable-packages”覆盖

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ];
    in
    rec {
      # custom packages
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );
      # Devshell 用于引导启动
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );

      # 将你定制的软件包和修改以叠加包的形式输出
      overlays = import ./overlays { inherit inputs; };
      # 您可能希望导出可重用的 NixOS 模块，这些通常是您要上游到 Nixpkgs 的内容
      nixosModules = import ./modules/nixos;
      # 您可能希望导出可重用的 home-manager 模块，这些通常是您要上游到 home-manager 的内容
      homeManagerModules = import ./modules/home-manager;

      # NixOS 配置入口点
      # 通过 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        # 请更改为您的主机名
        legion = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            # > 主要 NixOS 配置文件 <
            ./nixos/configuration.nix
          ];
        };
      };

      # 独立的 home-manager 配置入口
      # 通过 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        # 请更改为您的 username@hostname
        "nix@legion" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            # > 主 home-manager 配置文件 <
            ./home-manager/home.nix
          ];
        };
      };
    };
}
