{
  description = "nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # 可以同时访问不同nixpkgs版本的软件包和模块
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # 此外,请查看'overlays/default.nix'中的'unstable-packages'覆盖

    # 添加 NUR 仓库
    nur.url = "github:nix-community/NUR";
    # 强制 NUR 和 flake 使用相同版本的 nixpkgs
    nur.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # 添加其他flake
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

  };

  outputs = { self, nixpkgs, home-manager, nur, nixos-hardware, ... }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
    in rec {
      # 自定义包,可通过'nix build'、'nix shell'等访问
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; });
      # 用于引导的 Devshell,可通过'nix develop'或'nix-shell'访问
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; });

      # 将定制的软件包和修改以叠加包的形式输出
      overlays = import ./overlays { inherit inputs; };
      # 导出可重用的 NixOS 模块,通常是上游到 Nixpkgs 的内容
      nixosModules = import ./modules/nixos;
      # 导出的可重复使用的home-manager模块,通常是上游到 home-manager 的东西
      homeManagerModules = import ./modules/home-manager;

      # NixOS 配置入口点,通过 'nixos-rebuild --flake .#legion'
      nixosConfigurations = {
        # 请更改为主机名
        legion = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            # > NixOS 配置文件 <
            ./nixos/configuration.nix
            nixos-hardware.nixosModules.common-gpu-nvidia-disable
            nur.nixosModules.nur
            ({ config, ... }: {
              # 使用 NUR 提供的包
              environment.systemPackages = with config.nur.repos; [
                # xddxdd.dingtalk
                ruixi-rebirth.fcitx5-pinyin-moegirl
                ruixi-rebirth.fcitx5-pinyin-zhwiki
              ];
            })
            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.users.yrumily = import ./home-manager/home.nix;
              home-manager.extraSpecialArgs = { inherit inputs outputs; };
            }
          ];
        };
      };

      # 独立的home-manager配置入口点,可通过'home-manager --flake .#yrumily@legion'获得
      homeConfigurations = {
        # 替换为用户名@主机名
        "yrumily@legion" = home-manager.lib.homeManagerConfiguration {
          pkgs =
            nixpkgs.legacyPackages.x86_64-linux; # Home-manager 需要 'pkgs' 实例
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            # > home-manager配置文件<
            ./home-manager/home.nix
          ];
        };
      };
    };
}
