{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    # 在 flake 中使用 modules/nixos 模块
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # 禁用 nvidia
    # inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable

    # 将配置分解并在此导入其各个部分:
    # ./users.nix

    # 导入您生成的(nixos-generate-config)硬件配置
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

      # 或者内联定义它,例如:
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
    # 将每个 flake 输入作为注册表添加到 nix 命令中,以使它们与您的 flake 保持一致
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # 使您的输入进一步添加到系统通道中,同时使传统的nix命令保持一致
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    settings = {
      # 启用 flakes 和新的 nix 命令
      experimental-features = "nix-command flakes";
      substituters = [
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://mirrors.bfsu.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://cache.nixos.org/"
      ];
      extra-substituters = [
        "https://nix-community.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];
      trusted-users = [ "root" "@wheel" ];
      # 去重和优化nix存储
      auto-optimise-store = true;
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  networking.hostName = "legion"; # 定义主机名
  # 选择以下网络选项之一
  # networking.wireless.enable = true;  # 通过 wpa_supplicant 启用无线支持
  networking.networkmanager.enable = true; # 大多数发行版默认使用它

  # 使用 systemd-boot EFI 引导加载程序
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      systemd-boot = {
        enable = true;
        graceful = true;
        configurationLimit = 5;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
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
    initrd.kernelModules = [ "btrfs" ];
    kernelModules = [
      "v4l2loopback"
      "bbswitch"
      "amdgpu"
      "nvidia"
      "nvidia_drm"
      "nvidia_uvm"
      "nvidia_modeset"
    ];
    extraModulePackages = [
      pkgs.linuxKernel.packages.linux_zen.bbswitch
      pkgs.linuxKernel.packages.linux_zen.v4l2loopback
    ];
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 video_nr=9 card_label="obs"
    '';
  };

  # 设置时区
  time.timeZone = "Asia/Shanghai";

  # 配置网络代理
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # 选择国际化属性
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # 在 tty 中使用 xkbOptions
  # };

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      sarasa-gothic
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" "Noto Color Emoji" ];
        sansSerif = [ "Sarasa UI SC" "Noto Color Emoji" ];
        monospace = [ "Sarasa Mono SC" "Noto Color Emoji" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-kde ];
  };

  # 启用声音
  sound.enable = true;
  # hardware.pulseaudio.enable = true;
  hardware = {
    nvidia = {
      package = pkgs.linuxKernel.packages.linux_lqx.nvidia_x11_vulkan_beta_open;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      open = true;
      nvidiaSettings = true;
      modesetting.enable = true;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };
    };
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        nvidia-vaapi-driver
        libvdpau-va-gl
      ];
    };
    # 平滑背光控制
    brillo.enable = true;
    cpu.amd.updateMicrocode = true;
    bluetooth.enable = true;
    # 禁用nvidia
    nvidiaOptimus.disable = false;
  };

  users.users.root.initialPassword = "root";
  users.users.root.shell = pkgs.zsh;
  # 定义一个用户帐户,不要忘记使用'passwd'设置密码
  users.users.yrumily = {
    initialPassword = "yru";
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups =
      [ "wheel" "networkmanager" "users" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      vscode
      haruna
      firefox
      bitwarden
      google-chrome
      unstable.clash-verge
      unstable.clash-geoip
      unstable.clash-meta
      localsend
      telegram-desktop
      (python311.withPackages (ps: with ps; [ selenium ]))
    ];
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-with-addons fcitx5-chinese-addons ];
  };

  environment.shells = with pkgs; [ bashInteractive zsh fish ];

  environment.variables = {
    EDITOR = "helix";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
  };

  # 列出系统配置文件中安装的软件包,要搜索,请运行：
  # $ nix search wget
  # 不要忘记添加一个编辑器来编辑configuration.nix,Nano 编辑器是默认安装的
  environment.systemPackages = with pkgs; [
    helix
    wget
    git
    tealdeer
    neovim
    eza
    fastfetch
    ranger
    lazygit
    fzf
    bat
    fd
    ripgrep
    mcfly
    thefuck
    gdu
    duf
    htop
    python311
    alacritty
    qt6Packages.qtstyleplugin-kvantum
    libsForQt5.lightly
    # papirus-icon-theme
    orchis-theme
    colloid-kde
    tela-icon-theme
    vimix-cursor-theme
  ];

  environment.plasma5.excludePackages = with pkgs; [
    libsForQt5.kwrited
    libsForQt5.okular
    libsForQt5.elisa
    libsForQt5.kate
    libsForQt5.konsole
  ];

  # 有些程序需要 SUID 包装器,可以进一步配置或在用户会话中启动
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs = {
    xwayland.enable = true;
    zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestions = {
        enable = true;
        strategy = [ "history" ];
      };
    };
    fish = { enable = true; };
    fzf.fuzzyCompletion = true;
    firefox = { languagePacks = [ "zh-CN" ]; };
  };

  qt = {
    enable = true;
    platformTheme = "kde";
  };

  # 列出您要启用的服务
  services = {
    auto-cpufreq.enable = true;
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" ];
    };
    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    xserver = {
      # 启用 X11 窗口系统
      enable = true;
      displayManager = {
        # 启用 Plasma 5 桌面环境
        sddm.enable = true;
        autoLogin = {
          enable = true;
          user = "yrumily";
        };
      };
      desktopManager = {
        xterm.enable = false;
        plasma5 = {
          notoPackage = pkgs.noto-fonts-cjk-sans;
          enable = true;
        };
      };
      excludePackages = with pkgs; [
        xterm
        libsForQt5.kwrited
        libsForQt5.okular
        libsForQt5.elisa
        libsForQt5.kate
        libsForQt5.konsole
      ];
      # 在 X11 中配置键盘映射
      # layout = "us";
      # xkbOptions = "eurosign:e,caps:escape";
      # 启用触摸板支持(在大多数桌面管理器中默认启用)
      libinput = {
        enable = true;
        mouse = { accelProfile = "adaptive"; };
        touchpad = {
          tapping = true;
          naturalScrolling = true;
          accelProfile = "adaptive";
          disableWhileTyping = true;
        };
      };
    };
    # 启用 CUPS 打印文档
    # printing.enable = true;
  };

  # 启用 OpenSSH 守护进程
  # services.openssh.enable = true;
  # 设置一个 SSH 服务器
  services.openssh.enable = false;

  # 在防火墙中打开端口
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # 或者完全禁用防火墙
  networking.firewall.enable = false;

  # 从(/run/current-system/configuration.nix)复制 NixOS 配置文件,如果不小心删除了configuration.nix,这很有用
  # system.copySystemConfiguration = true;

  # 该值决定了默认的 NixOS 版本,在更改此值之前,请阅读此选项的文档(例如 man configuration.nix 或 https://nixos.org/nixos/options.html)
  system.stateVersion = "23.11";
}
