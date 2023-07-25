{
  description = "nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    # 您可以同时访问不同nixpkgs版本的软件包和模块。这里是一个工作示例:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # 此外，请查看“overlays/default.nix”中的“unstable-packages”覆盖

    nixos-cn = {
    url = "github:nixos-cn/flakes";
    inputs.nixpkgs.follows = "nixpkgs";
    };
    nixConfig = {
    experimental-features = [
        "nix-command" "flakes"
      ];
    substituters = [
      "https://mirrors.bfsu.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
      "https://nixos-cn.cachix.org"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      ];
    extra-substituters = [];
    extra-trusted-public-keys = [
        "nixos-cn.cachix.org-1:L0jEaL6w7kwQOPlLoCR3ADx+E3Q8SEFEcB9Jaibl0Xg="
      ];
    };
    hyprland.url = "github:hyprwm/Hyprland";
    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager,hyprland,nixos-cn, ...
  }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
    "x86_64-linux"
  ];
    in
    rec {
      # custom packages
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system
    };
        in import ./pkgs { inherit pkgs;
    }
      );
      # Devshell 用于引导启动
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system
    };
        in import ./shell.nix { inherit pkgs;
    }
      );

      # 将你定制的软件包和修改以叠加包的形式输出
      overlays = import ./overlays { inherit inputs;
    };
      # 您可能希望导出可重用的 NixOS 模块，这些通常是您要上游到 Nixpkgs 的内容
      nixosModules = import ./modules/nixos;
      # 您可能希望导出可重用的 home-manager 模块，这些通常是您要上游到 home-manager 的内容
      homeManagerModules = import ./modules/home-manager;

      # NixOS 配置入口点
      # 通过 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        # 请更改为您的主机名
        legion = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs;
        };
          modules = [
            # > 主要 NixOS 配置文件 <
            ./nixos/configuration.nix
            nixos-cn.nixosModules.nixos-cn-registries
            nixos-cn.nixosModules.nixos-cn
        ];
      };
    };
  };
}