{
  inputs,
  outputs,
  vars,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    outputs.nixosModules.shared
    outputs.nixosModules.fcitx5
    outputs.nixosModules.chromium
    outputs.nixosModules.gnome
    outputs.nixosModules.steam
    outputs.nixosModules.nvidia-disable
    # outputs.nixosModules.nvidia
    # outputs.nixosModules.containers

    ./hardware-configuration.nix

    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-hardware.nixosModules.lenovo-legion-15arh05h
    inputs.nix-index-database.nixosModules.nix-index
  ];

  home-manager.users."${vars.users.users.user.username}" = import ../home-manager/home.nix;

  nixpkgs.overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      inputs.nur.overlay
      # outputs.overlays.unstable-small-packages
      # inputs.nixpkgs-wayland.overlay
      # inputs.chaotic.nixosModules.default
    ];

  networking = {
    timeServers = [
      "ntp.ntsc.ac.cn"
      "cn.ntp.org.cn"
      "ntp.aliyun.com"
      "ntp.tencent.com"
      "0.nixos.pool.ntp.org"
      "1.nixos.pool.ntp.org"
      "2.nixos.pool.ntp.org"
      "3.nixos.pool.ntp.org"
    ];
    nameservers = [
      "223.5.5.5#dns.alidns.com"
      "8.8.8.8#dns.google"
    ];
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi = {
        powersave = true;
        macAddress = "stable-ssid";
      };
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        consoleMode = "auto";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      timeout = 4;
    };
    kernelParams = vars.boot.kernelParams;
    consoleLogLevel = 3;
    kernelModules = vars.boot.kernelModules;
    extraModulePackages = vars.boot.extraModulePackages config.boot.kernelPackages;
    extraModprobeConfig = vars.boot.extraModprobeConfig;
    tmp.useTmpfs = true;
    supportedFilesystems = [ config.fileSystems."/".fsType ];
  };

  i18n = {
    inputMethod = {
      enabled = "fcitx5";
      fcitx5 = {
        plasma6Support = true;
        addons = with pkgs; [
          fcitx5-gtk
          fcitx5-with-addons
          fcitx5-chinese-addons
        ];
        waylandFrontend = true;
      };
    };
  };

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      sarasa-gothic
      source-han-mono
      source-han-serif-vf-otf
      source-han-sans-vf-otf
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif CJK SC" ];
        sansSerif = [ "Sarasa UI SC" ];
        monospace = [ "Sarasa Mono SC" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  xdg = {
    terminal-exec.enable = true;
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
    mime = {
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "application/pdf" = "firefox.desktop";
        "image/jpeg" = "org.gnome.Loupe.desktop";
        "image/png" = "org.gnome.Loupe.desktop";
        "image/gif" = "org.gnome.Loupe.desktop";
        "image/webp" = "org.gnome.Loupe.desktop";
        "image/tiff" = "org.gnome.Loupe.desktop";
        "image/x-tga" = "org.gnome.Loupe.desktop";
        "image/vnd-ms.dds" = "org.gnome.Loupe.desktop";
        "image/x-dds" = "org.gnome.Loupe.desktop";
        "image/bmp" = "org.gnome.Loupe.desktop";
        "image/vnd.microsoft.icon" = "org.gnome.Loupe.desktop";
        "image/vnd.radiance" = "org.gnome.Loupe.desktop";
        "image/x-exr" = "org.gnome.Loupe.desktop";
        "image/x-portable-bitmap" = "org.gnome.Loupe.desktop";
        "image/x-portable-graymap" = "org.gnome.Loupe.desktop";
        "image/x-portable-pixmap" = "org.gnome.Loupe.desktop";
        "image/x-portable-anymap" = "org.gnome.Loupe.desktop";
        "image/x-qoi" = "org.gnome.Loupe.desktop";
        "image/svg+xml" = "org.gnome.Loupe.desktop";
        "image/svg+xml-compressed" = "org.gnome.Loupe.desktop";
        "image/avif" = "org.gnome.Loupe.desktop";
        "image/heic" = "org.gnome.Loupe.desktop";
        "image/jxl" = "org.gnome.Loupe.desktop";
        # "text/plain"="Helix.desktop";
      };
      # addedAssociations = {
      #   "text/plain" = "dev.zed.Zed.desktop";
      # };
    };
  };

  sound.enable = true;

  hardware = {
    enableRedistributableFirmware = true;
    pulseaudio.enable = false;
    graphics = {
      enable = true;
      extraPackages = vars.hardware.graphics.extraPackages pkgs;
    };
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
      disabledPlugins = [
        "bap"
        "bass"
        "mcp"
        "vcp"
        "micp"
        "ccp"
        "csip"
      ];
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  users.users."${vars.users.users.user.username}".packages =
        # shell
        (with pkgs; [
          # ouch
          chezmoi
          typst
          ruff
          git-credential-manager
        ])
        ++ (with pkgs; [
          pot
          celluloid
          localsend
          popsicle
          alacritty-theme
          gitkraken
          # zed-editor
          # nomacs
          # jetbrains.idea-ultimate
        ])
        # theme
        ++ (with pkgs; [
          (papirus-icon-theme.override { color = "adwaita"; })
          orchis-theme
        ])
        # custom
        ++ (with pkgs; [
          hiddify-next
          gopeed
          navicat
          damask
        ]);

  environment = {
    variables = {
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      SDL_IM_MODULE = "fcitx";
      GLFW_IM_MODULE = "ibus";
    };
    sessionVariables.MOZ_USE_XINPUT2 = "1";
    systemPackages =
      (with pkgs; [
        nil
      ])
      # ++ (with pkgs; [
      #   lenovo-legion
      # ])
      ++ (with pkgs; [
        difftastic
        sops
        helix
        gitleaks
        eza
        fzf
        bat
        fd
        ripgrep-all
        typos
        lnav
        uutils-coreutils-noprefix
        nvtopPackages.amd
      ])
      # Python Package
      ++ (with pkgs; [
        uv
        (python3.withPackages (
          ps: with ps; [
            requests
            python-dotenv
          ]
        ))
      ])
      # FHS
      ++ (with pkgs; [
        (
          let
            base = pkgs.appimageTools.defaultFhsEnvArgs;
          in
          pkgs.buildFHSEnv (
            base
            // {
              name = "fhs";
              targetPkgs =
                pkgs:
                (base.targetPkgs pkgs)
                ++ (with pkgs; [
                  pkg-config
                  python3
                  uv
                ]);
              profile = "export FHS=1";
              runScript = "fish";
              extraOutputsToInstall = [ "dev" ];
              extraBwrapArgs = [ "--symlink /.host-etc/gitconfig /etc/gitconfig" ];
            }
          )
        )
      ]);
  };

  programs = {
    nix-index = {
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
    };
    nix-index-database.comma.enable = true;
    adb.enable = true;
    clash-verge = {
      enable = true;
      package = pkgs.clash-nyanpasu;
    };
    # java = {
    #   enable = true;
    #   package = pkgs.jetbrains.jdk;
    # };
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "alacritty";
    };
    firefox = {
      enable = true;
      languagePacks = [ "zh-CN" ];
      preferencesStatus = "default";
    };
  };

  qt.enable = true;

  services = {
    sunshine = {
      enable = true;
      autoStart = false;
      capSysAdmin = true;
    };
    # locate = {
    #   enable = true;
    #   interval = "weekly";
    #   package = pkgs.plocate;
    # };
    timesyncd = {
      enable = false;
      # extraConfig = ''
      #   PollIntervalMinSec=4d
      #   PollIntervalMaxSec=7w
      #   SaveIntervalSec=infinity
      # '';
    };
    geoclue2.enable = false;
    psd.enable = true;
    thermald.enable = false; # intel
    fstrim.enable = if config.fileSystems."/".fsType == "bcachefs" then false else true;
    # gpm.enable = true; # 为 Linux 虚拟控制台提供鼠标支持
    kmscon = {
      # Instead of vt
      enable = true;
      fonts = [
        {
          name = "Sarasa Mono SC";
          package = pkgs.sarasa-gothic;
        }
      ];
      extraConfig = "font-size=20";
      hwRender = true;
      useXkbConfig = true;
    };
    resolved = {
      enable = true;
      dnsovertls = "true";
      domains = [ "~." ];
      fallbackDns = [
        "1.1.1.1#one.one.one.one"
        "1.0.0.1#one.one.one.one"
        "2400:3200::1"
        "2606:4700:4700::1001"
      ];
    };
    acpid.enable = true;
    btrfs.autoScrub.enable = if config.fileSystems."/".fsType == "btrfs" then true else false;
    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      settings = {
        TLP_DEFAULT_MODE = "BAT";
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_TRESH_BAT0 = 80;
        STOP_CHARGE_THRESH_BAT0 = 1;
        DISK_DEVICES = "nvme0n1";
        RESTORE_DEVICE_STATE_ON_STARTUP = 1;
        RUNTIME_PM_ON_AC = "auto";
        USB_EXCLUDE_AUDIO = 0;
      };
    };
    upower = {
      enable = true;
      noPollBatteries = true;
    };
    auto-cpufreq = {
      enable = false; # if config.services.tlp.enable then false else true;
      settings = {
        charger.governor = "schedutil";
        battery = {
          enable_thresholds = true;
          start_threshold = 70;
          stop_threshold = 75;
        };
      };
    };
    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    libinput = {
      enable = true;
      mouse.accelProfile = "adaptive";
      touchpad = {
        tapping = true;
        naturalScrolling = true;
        accelProfile = "adaptive";
        disableWhileTyping = true;
      };
    };
    displayManager.autoLogin = {
      enable = true;
      user = vars.users.users.user.username;
    };
    xserver = {
      enable = true;
      videoDrivers = vars.services.xserver.videoDrivers;
      desktopManager.xterm.enable = false;
      excludePackages = with pkgs; [ xterm ];
      xkb.model = "pc105";
      wacom.enable = false;
    };
    # flatpak.enable = true;
    # printing.enable = true;
  };

  systemd = {
    # network.wait-online.enable = false;
    coredump.extraConfig = ''
      Storage=none
      ProcessSizeMax=0
    '';
    sleep.extraConfig = ''
      AllowHibernation=no
    '';
    services = {
      # NetworkManager-wait-online.enable = lib.mkForce false;
      systemd-gpt-auto-generator.enable = false;
      alsa-store.enable = false;
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
      keyboard-brightness = {
        description = "Set keyboard brightness after resume";
        wantedBy = [
          "sleep.target"
          "suspend.target"
          "hibernate.target"
        ];
        serviceConfig = {
          Type = "oneshot";
          WorkingDirectory = "/sys/class/leds/platform::kbd_backlight/";
          ExecStart = "${pkgs.bash}/bin/sh -c \"cat brightness >> /var/tmp/kbd_brightness_current && echo 0 > brightness\"";
          ExecStop = "${pkgs.bash}/bin/sh -c 'sleep 3s && cat /var/tmp/kbd_brightness_current > brightness && rm /var/tmp/kbd_brightness_current'";
        };
      };
      numlock-brightness = {
        description = "Set numlock Brightness";
        after = [
          "graphical.target"
          "sleep.target"
          "suspend.target"
          "hibernate.target"
        ];
        wantedBy = [
          "graphical.target"
          "sleep.target"
          "suspend.target"
          "hibernate.target"
        ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          WorkingDirectory = "/sys/class/leds/";
          ExecStart = "${pkgs.bash}/bin/sh -c 'sleep 3s && for dir in ./*::numlock*/; do [ -d \"$dir\" ] && echo 0 > \"$dir/brightness\"; done'";
          User = "root";
        };
      };
    };
  };
}
