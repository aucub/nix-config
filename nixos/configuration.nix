# 系统配置文件
# 使用此文件来配置您的系统环境 (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    git
    lazygit
    fish
    bluez
    bluez-alsa
    bluez-tools
    tealdeer
    neovim
    helix
    alacritty
    vim
    sshpass
    curl
    neofetch
    nnn
    ranger
    exa
    fzf
    bat
    fd
    ripgrep
    mcfly
    zoxide
    thefuck
    du-dust
    duf
    jq
    ethtool
    networkmanagerapplet
    wget
    curl
    aria
    socat
    libnotify
    sysstat
    lm_sensors
    hdparm
    pciutils
    dmidecode
    brightnessctl
    glib
    xdg-utils
    xdg-user-dirs
    btop
    htop
    gcc
    clang
    rar
    xz
    unzip
    p7zip
    atool
    bc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    ffmpeg_6-full
    ffmpegthumbnailer
    pavucontrol
    playerctl
    pulsemixer
    pipewire
    wireplumber
    alsa-lib
    alsa-utils
    flac
    audacity
    libva
    libva-utils
    vaapiVdpau
    vdpauinfo
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
    glxinfo
    mesa
    viu
    imagemagick
    imv
    feh
    graphviz
    obs-studio
    mpd
    cava
    mpc-cli
    ncmpcpp
    wayland
    wayland-scanner
    wayland-utils
    wev
    egl-wayland
    wayland-protocols
    glfw-wayland
    xwayland
    xorg.xrdb
    qt6.qtwayland
    libsForQt5.qt5.qtwayland
    qt5ct
    polkit_gnome
    linux-firmware
    greetd.greetd
    greetd.gtkgreet
    xfce.thunar
    gnome.dconf-editor
    lxappearance
  ];

  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  # 可以在这里导入其他 NixOS 模块
  imports = [
    # 在 flake 中使用模块（来自 modules/nixos）:
    # outputs.nixosModules.example
    ../modules/nixos/default.nix

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
      # });
      #})
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
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      substituters = [
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://mirrors.bfsu.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://cache.nixos.org/"
      ];
      # 去重和优化nix存储
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
      warn-dirty = false;
    };

    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  # 添加您当前配置的其余部分
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions = {
        enable = true;
        strategy = [ "match_prev_cmd" ]; # one of "history", "match_prev_cmd"
      };
      enableGlobalCompInit = false;
      promptInit = "";
    };
    gnupg = {
      enable = true;
      agent = {
        enable = true;
        pinentryFlavor = "gnome3"
      }
    };
    dconf.enable = true;
    ssh.startAgent = true;
    fuse.userAllowOther = true;
    neovim.enable = true;
  };

  networking = {
    firewall.enable = false;
    hostName = "legion";
    networkmanager.enable = true;
  };

  time = {
    timeZone = "Asia/Shanghai";
    hardwareClockInLocalTime = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
    extraLocaleSettings = {
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
  };

  console.keyMap = "us";

  boot = {
    kernelPackages = pkgs.linuxPackages_lqx;
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        configurationLimit = lib.mkDefault 10;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      timeout = 4;
    };
    kernelParams = [
      "amd_pstate=passive"
      "amdgpu.vm_update_mode=3"
      "radeon.dpm=0"
      "nvidia-drm.modeset=1"
      "NVreg_PreserveVideoMemoryAllocations=1"
      "amd_pstate=passive"
    ];
    consoleLogLevel = 3;
    initrd.verbose = false;
    initrd.kernelModules = [ "btrfs" ];
    kernelModules = [
      "fuse"
      "v4l2loopback"
      "acpi_call"
      "bbswitch"
      "amdgpu"
      "nvidia"
      "nvidia_drm"
      "nvidia_uvm"
      "nvidia_modeset"
    ];
    extraModulePackages = [
      pkgs.linuxKernel.packages.linux_lqx.bbswitch
      pkgs.linuxKernel.packages.linux_lqx.acpi_call
      pkgs.linuxKernel.packages.linux_lqx.v4l2loopback
    ];
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 video_nr=9 card_label="obs"
    '';
    supportedFilesystems = lib.mkForce [
      "btrfs"
      "reiserfs"
      "vfat"
      "f2fs"
      "xfs"
      "ntfs"
      "cifs"
      "ext4"
    ];
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    user.targets.hyprland-session.Unit.Wants =
      [ "xdg-desktop-autostart.target" ];
    services.NetworkManager-wait-online.enable = false;
    oomd = {
      enableRootSlice = true;
      enableUserServices = true;
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    pam.services.greetd.enableGnomeKeyring = true;
    sudo = { enable = true; };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = false;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr # for   wlroots   based compositors(hyprland/  sway)
      xdg-desktop-portal-gtk # for gtk
      # xdg-desktop-portal-kde  # for kde
    ];
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  environment.shells = with pkgs; [ bash zsh fish ];

  # 配置您的全局用户，组设置，根据需要添加更多用户
  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.zsh;
    users = {
      root.initialPassword = "root";
      # 将其替换为您的用户名
      nix = {
        # 可以为您的用户设置一个初始密码，如果您这样做了，您可以通过在nixos-install中传递“--no-root-passwd”来跳过设置根密码
        # 在重新启动后一定记得用passwd更改密码
        shell = pkgs.zsh;
        initialPassword = "nix";
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          # 如果您打算使用SSH连接，请在此处添加您的SSH公钥
        ];
        uid = 1000;
        # 要添加您需要的任何其他组 (such as networkmanager, audio, docker, etc)
        extraGroups = [
          "wheel"
          "docker"
          "libvirtd"
          "users"
          "networkmanager"
          "systemd-journal"
          "audio"
          "video"
          "input"
          "lp"
          "power"
          "nix"
        ];
      };
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      pinentryFlavor = "gnome3";
    };
    acpid.enable = true;
    btrfs.autoScrub.enable = true;
    getty.autologinUser = "nix";
    gnome.gnome-keyring.enable = true;
    dbus.packages = [ pkgs.gcr ];
    geoclue2.enable = true;
    udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
      platformio
      openocd
      android-udev-rules
      ledger-udev-rules
    ];
    udisks2.enable = true;
    # 设置SSH服务器
    openssh = {
      enable = false;
      settings = {
        # 禁止通过SSH登录root账户
        PermitRootLogin = "no"; # 仅使用密钥进行 SSH 登录
        PasswordAuthentication = true;
      };
      openFirewall = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';
    fstrim.enable = true;
    printing = {
      enable = false;
      drivers = [ pkgs.epson-escpr ];
    };
    fwupd.enable = true;
    gvfs.enable = true; # Mount, trash, and   other functionalities
    tumbler.enable = true; # Thumbnail   support for images
    upower.enable = true;
    blueman.enable = true;
    flatpak.enable = true;
    xserver = {
      enable = true;
      layout = "us";
      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          naturalScrolling = true;
          disableWhileTyping = true;
        };
      };
    };
    avahi = {
      enable = true;
      nssmdns = true;
    };
  };

  sound.enable = true;

  hardware = {
    pulseaudio.enable = false;
    opengl = {
      enable = true;
      driSupport = true;
    };
    # 平滑背光控制
    brillo.enable = true;
    bluetooth.enable = true;
    cpu.amd.updateMicrocode = true;
  };

  system.stateVersion = "23.05";
}