# 您的home-manager配置文件
# 使用此文件来配置您的主目录环境(it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # 您可以在此处导入其他的home-manager模块
  imports = [
    # 如果您想使用您自己的flake导出的模块，可以按下面的方式配置(from modules/home-manager):
    # outputs.homeManagerModules.example
    
  
    # 或者使用其他flake导出的模块也可以按下面的方式配置(such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # 在这里，您也可以分割您的配置并导入其各个部分
    # ./nvim.nix
  ];

  nixpkgs = {
    # 可以在这里添加overlays（覆盖）
    overlays = [
      # （您可以）为您自己的flake导出添加覆盖 (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # 也可以添加从其他flakes导出的覆盖层:
      # neovim-nightly-overlay.overlays.default

      # 或者内联定义它，例如:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # 配置你的 nixpkgs 实例
    config = {
      # 如果你不想要不自由的软件包，可以禁用它
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  # 设置你的用户名
  home = {
    username = "nix";
    homeDirectory = "/home/nix";
  };

  # 根据需要为你的用户添加所需的内容:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # 启用 home-manager and git
  programs.home-manager.enable = true;

  # git 相关配置
  programs.git = {
    enable = true;
    userName = "aucub";
    userEmail = "78630225+aucub@users.noreply.github.com";
    ignores = [
      ".cache/"
      ".DS_Store"
      ".idea/"
      "node_modules"
      ".vscode"
    ];
    extraConfig = {
      init.defaultBranch = "master"; 
      core.editor = "nvim";
    };
  };

  # 通过 home.packages 安装一些常用的软件
  # 这些软件将仅在当前用户下可用，不会影响系统级别的配置
  # 建议将所有 GUI 软件，以及与 OS 关系不大的 CLI 软件，都通过 home.packages 安装
  home.packages = with pkgs;[
    wezterm
    firefox
    flameshot
    cargo
    celluloid
    clash-meta
    clash-geoip
    clash-verge
  ];

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };
    theme = {
      name = "Orchis theme";
      package = pkgs.orchis-theme;
    };
    font = {
      name = "Sarasa UI SC";
      size = 12;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    gtk.enable = true;
    x11.enable = true;
    size = 24;
  };

  services = {
    network-manager-applet.enable = true;
    blueman-applet.enable = true;
  };

  # 在更改配置时，优雅地重新加载系统单元
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.05";
}
