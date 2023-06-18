# 系统配置文件
# 使用此文件来配置您的系统环境 (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  nix.settings.substituters = [ "https://mirrors.bfsu.edu.cn/nix-channels/store" ];
  # 可以在这里导入其他 NixOS 模块
  imports = [
    inputs.home-manager.nixosModules.home-manager
    # 在 flake 中使用模块（来自 modules/nixos）:
    # outputs.nixosModules.example

    # 或者来自其他 flake 的模块(such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # 将配置分解并在此导入其各个部分:
    # ./users.nix

    # 导入您生成的（nixos-generate-config）硬件配置
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # 可以在此添加覆盖
    overlays = [
      # 将 flake 导出添加为覆盖层 (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # 可以添加从其他 flake 导出的覆盖:
      # neovim-nightly-overlay.overlays.default

      # 或者内联定义它，例如:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # 配置 nixpkgs 实例
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    # 将每个 flake 输入作为注册表添加到 nix3 命令中，以使它们与您的 flake 保持一致
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # 使您的输入进一步添加到系统通道中
    # 同时使传统的nix命令保持一致
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # 去重和优化nix存储
      auto-optimise-store = true;
    };
  };

  # 添加您当前配置的其余部分

  networking = {
    hostName = "legion";
    networkmanager.enable = true;
  };

  time = {
    timeZone = "Asia/Shanghai";
    hardwareClockInLocalTime = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-chinese-addons fcitx5-table-extra ];
  };

  # 设置您的主机名
  networking.hostName = "nix";

  # 只是一个例子，请务必使用您喜欢的启动程序
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    bootspec.enable = true;
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      timeout = 3;
    };
    kernelParams = [
      "nvidia-drm.modeset=1"
      "NVreg_PreserveVideoMemoryAllocations=1"
      "amd_pstate=passive"
    ];
    consoleLogLevel = 3;
    initrd.verbose = false;
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
  security.polkit.enable = true;
  security.sudo = {
    enable = false;
    extraConfig = ''
      nix ALL=(ALL) NOPASSWD:ALL
    '';
  };
  security.doas = {
    enable = true;
    extraConfig = ''
      permit nopass :wheel
    '';
  };

  services = {
    dbus = {
      packages = with pkgs; [dconf gcr udisks2];
      enable = true;
    };
    udev.packages = with pkgs; [gnome.gnome-settings-daemon android-udev-rules ledger-udev-rules];
    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';
    udisks2.enable = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # 配置您的全局用户，组设置，根据需要添加更多用户
  users.users = {
    # 将其替换为您的用户名
    nix = {
      # 可以为您的用户设置一个初始密码，如果您这样做了，您可以通过在nixos-install中传递“--no-root-passwd”来过设置根密码
      # 在重新启动后一定记得用passwd更改密码
      shell = pkgs.zsh;
      initialPassword = "nix";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # 如果您打算使用SSH连接，请在此处添加您的SSH公钥
      ];
      uid = 1000;
      # 要添加您需要的任何其他组 (such as networkmanager, audio, docker, etc)
      extraGroups = [ "wheel" ];
    };
  };

  services.getty.autologinUser = "nix";

  # 设置一个SSH服务器，如果您正在设置一个无需显示器的系统，则非常重要。如果您不需要它，请随意将其删除
  services.openssh = {
    enable = false;
    # 禁止通过SSH登录root账户
    permitRootLogin = "no";
    # 仅使用密钥进行 SSH 登录，如果要使用密码进行 SSH 登录，请删除此设置
    passwordAuthentication = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
