# 系统配置文件
# 使用此文件来配置您的系统环境 (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
  # 命令行工具
  neofetch
  nnn
  ranger

  # utils
  exa
  fzf 
  bat
  fd
  rigrep
  mcfly
  du-dust
  duf
  jq

  # networking tools
  networkmanagerapplet
  wget
  curl
  aria2 
  socat

  # system tools
  pciutils
  dmidecode 

  # xdg
  xdg-utils 
  xdg-user-dirs

  # productivity
  btop
  htop
  nvtop
  gcc
  clang

  # archives
  zip
  rar
  xz
  unzip
  p7zip
  atool

  # misc
  cowsay
  file
  which
  tree
  gnused
  gnutar
  gawk
  zstd
  gnupg
  dkms

  # nix related
  nixos-conf-editor
  
  # video
  ffmpeg-full

  # audio control
  pavucontrol
  playerctl
  pulsemixer
  pipewire 
  pipewire-alsa 
  pipewire-audio 
  pipewire-jack 
  pipewire-pulse 
  alsa-lib
  alsa-utils
  flac

  # video/audio tools
  libva
  libva-utils
  vdpauinfo
  vulkan-loader
  vulkan-validation-layers
  vulkan-tools
  glxinfo
  mesa 
  mesa-utils

  # images
  viu 
  imagemagick
  graphviz

  # live streaming
  obs-studio

  # 用于播放系统音效
  mpd # for playing system sounds

  # wayland
  wayland
  wayland-scanner
  wayland-utils
  egl-wayland
  wayland-protocols
  pkgs.xorg.xeyes
  glfw-wayland
  xwayland
  pkgs.qt6.qtwayland

  # GUI
  alacritty
  pcmanfm
  
  # security
  polkit_gnome
  
  # system
  linux-firmware

  # bluetooth
  bluez
  bluez-libs 

  # editor
  neovim
  helix
  
];

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

  programs.dconf.enable = true;

  networking = {
    firewall.enable = false;
    hostName = "legion";
    networkmanager.enable = true;
  };

  time = {
    timeZone = "Asia/Shanghai";
    hardwareClockInLocalTime = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
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
  security.rtkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

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

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = false;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr # for wlroots based compositors(hyprland/sway)
      xdg-desktop-portal-gtk # for gtk
      # xdg-desktop-portal-kde  # for kde
    ];
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  environment.shells = with pkgs; [
    bash
    zsh
    fish
  ];
  users.defaultUserShell = pkgs.zsh;

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
      extraGroups = [ "wheel" "users" "networkmanager" ];
    };
  };

  services = {
    dbus.packages = [ pkgs.gcr ];
    geoclue2.enable = true;
    udev.packages = with pkgs; [gnome.gnome-settings-daemon   platformio android-udev-rules ledger-udev-rules];
    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';
    udisks2.enable = true;
  };

  services.getty.autologinUser = "nix";

  # 设置一个SSH服务器，如果您正在设置一个无需显示器的系统，则非常重要。如果您不需要它，请随意将其删除
  services.openssh = {
    enable = false;
    settings = {
      # 禁止通过SSH登录root账户
      PermitRootLogin = "no"; # 仅使用密钥进行 SSH 登录
      PasswordAuthentication = false;
    };
    openFirewall = true;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
  services.upower.enable = true;
  services.blueman.enable = true;
  services.flatpak.enable = true;

  sound.enable = false;
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;

  power-profiles-daemon = {
    enable = true;
  };

  programs.ssh.startAgent = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
