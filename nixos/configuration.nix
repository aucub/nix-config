{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    # 在 flake 中使用modules/nixos模块
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

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
    # 将每个 flake 输入作为注册表添加到 nix3 命令中,以使它们与您的 flake 保持一致
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
    kernelPackages = pkgs.linuxPackages_lqx;
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
      pkgs.linuxKernel.packages.linux_lqx.bbswitch
      pkgs.linuxKernel.packages.linux_lqx.v4l2loopback
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
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr ];
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
        libva
        libva-utils
        vdpauinfo
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
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      vscode
      haruna
      firefox
      clash
      clash-verge
      clash-geoip
      clash-meta
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

  environment.sessionVariables = {
    BROWSER = "firefox";
    TERMINAL = "alacritty";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    XCURSOR_THEME = "Nordzy-cursors";
    XCURSOR_SIZE = "32";
    GDK_SCALE = "1";
    ELM_SCALE = "1";
    QT_SCALE_FACTOR = "1";
    GDK_BACKEND = "wayland,x11";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "0";
    CLUTTER_BACKEND = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    LIBSEAT_BACKEND = "logind";
  };

  # 列出系统配置文件中安装的软件包,要搜索,请运行：
  # $ nix search wget
  # 不要忘记添加一个编辑器来编辑configuration.nix,Nano 编辑器是默认安装的
  environment.systemPackages = with pkgs; [
    bluez
    bluez-alsa
    bluez-tools
    brightnessctl
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
    xdg-utils
    xdg-user-dirs
    udiskie
    networkmanager
    libnma-gtk4
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
    linux-firmware
    waybar # the status bar
    swaybg # the wallpaper
    hyprland-protocols
    swayidle # the idle timeout
    swaylock # locking the screen
    nwg-bar
    wl-clipboard
    wl-clipboard-x11
    wl-clip-persist
    wlr-randr
    wf-recorder # creen recording
    grim # taking screenshots
    slurp # selecting a region to screenshot
    wofi
    mako # the notification daemon, the same as dunst
    swayosd
    yad # a fork of zenity, for creating dialogs
    hyprpicker
    swaylock-effects
    pamixer
    obs-studio-plugins.wlrobs
    alacritty
    libsForQt5.qtstyleplugin-kvantum
    qt5ct
    libsForQt5.lightly
    papirus-icon-theme
    orchis-theme
    nordzy-cursor-theme
    obs-studio
    obs-studio-plugins.obs-pipewire-audio-capture
    obs-studio-plugins.obs-scale-to-sound
    obs-studio-plugins.obs-vaapi
    nomacs
  ];

  # 有些程序需要 SUID 包装器,可以进一步配置或在用户会话中启动
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs = {
    gnome-disks.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable = true;
      enableNvidiaPatches = true;
    };
    xwayland.enable = true;
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions = {
        enable = true;
        strategy = [ "history" ];
      };
      promptInit = "";
    };
    firefox = { languagePacks = [ "zh-CN" ]; };
    fuse.userAllowOther = true;
    light.enable = true;
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  security.sudo = { enable = true; };

  # 列出您要启用的服务
  services = {
    auto-cpufreq.enable = true;
    udisks2.enable = true;
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
    gvfs.enable = true;
    tumbler.enable = true;
    upower.enable = true;
    blueman.enable = true;
    xserver = {
      # 启用 X11 窗口系统
      enable = true;
      displayManager = {
        autoLogin = {
          enable = true;
          user = "yrumily";
        };
      };
      desktopManager = { xterm.enable = false; };
      excludePackages = with pkgs; [ xterm ];
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
  # 设置一个 SSH 服务器,如果要设置无头系统,这一点非常重要,如果不需要,请随意删除
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
