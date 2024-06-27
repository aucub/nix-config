{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    outputs.nixosModules.fcitx5
    outputs.nixosModules.chromium
    outputs.nixosModules.gnome
    outputs.nixosModules.nvidia-disable
    # outputs.nixosModules.nvidia
    # outputs.nixosModules.containers

    ./hardware-configuration.nix

    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-hardware.nixosModules.lenovo-legion-15arh05h
    inputs.nix-index-database.nixosModules.nix-index
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs outputs;
    };
    users = {
      "${outputs.vars.users.users.user.username}" = import ../home-manager/home.nix;
    };
    backupFileExtension = "bak";
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      # outputs.overlays.unstable-small-packages
      inputs.nur.overlay
      # inputs.nixpkgs-wayland.overlay
      # inputs.chaotic.nixosModules.default
    ];
    config = {
      allowUnfree = lib.mkForce true;
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        experimental-features = "nix-command flakes";
        flake-registry = "";
        nix-path = config.nix.nixPath;
        auto-optimise-store = true;
        builders-use-substitutes = true;
        show-trace = true;
        warn-dirty = false;
        substituters = [
          "https://mirrors.ustc.edu.cn/nix-channels/store"
          # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          # "https://nixpkgs-wayland.cachix.org"
          # "https://qihaiumi.cachix.org"
          # "https://cosmic.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          # "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
          # "qihaiumi.cachix.org-1:Cf4Vm5/i3794SYj3RYlYxsGQZejcWOwC+X558LLdU6c="
          # "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
        ];
        trusted-users = [
          "root"
          "@wheel"
        ];
      };
      # nix-channel 命令和状态文件
      channel.enable = false;

      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 1w";
      };
    };

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
    hostName = outputs.vars.networking.hostName;
    firewall.enable = false;
    nameservers = [
      "223.5.5.5#dns.alidns.com"
      "8.8.8.8#dns.google"
    ];
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi = {
        backend = "iwd";
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
        graceful = true;
        configurationLimit = 10;
        consoleMode = "auto";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      timeout = 4;
    };
    kernelParams = outputs.vars.boot.kernelParams;
    consoleLogLevel = 3;
    kernelModules = outputs.vars.boot.kernelModules;
    blacklistedKernelModules = [ "nouveau" ];
    extraModulePackages = outputs.vars.boot.extraModulePackages pkgs;
    extraModprobeConfig = lib.mkForce outputs.vars.boot.extraModprobeConfig;
    tmp.useTmpfs = true;
    supportedFilesystems = [ config.fileSystems."/".fsType ];
    initrd = {
      supportedFilesystems = [ config.fileSystems."/".fsType ];
      kernelModules = [ config.fileSystems."/".fsType ];
    };
  };

  time.timeZone = "Asia/Shanghai";

  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    supportedLocales = [
      "zh_CN.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
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
      (nerdfonts.override {
        fonts = [
          "NerdFontsSymbolsOnly"
          "Iosevka"
        ];
      })
      twitter-color-emoji
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "Noto Serif CJK SC"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Sarasa UI SC"
          "Noto Color Emoji"
        ];
        monospace = [
          "Sarasa Mono SC"
          "Noto Color Emoji"
        ];
        emoji = [
          "Twemoji"
          "Noto Color Emoji"
        ];
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

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo-rs.enable = true;
  };

  hardware = {
    enableAllFirmware = true;
    wirelessRegulatoryDatabase = lib.mkForce false;
    firmware = with pkgs; [ linux-firmware ];
    pulseaudio.enable = false;
    graphics = {
      enable = true;
      extraPackages = outputs.vars.hardware.graphics.extraPackages pkgs;
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

  users.users = {
    root = {
      initialHashedPassword = "${outputs.vars.users.users.root.initialHashedPassword}";
      shell = pkgs.bashInteractive;
    };
    "${outputs.vars.users.users.user.username}" = {
      uid = 1000;
      initialHashedPassword = "${outputs.vars.users.users.user.initialHashedPassword}";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDk688qD+dBPXh53bQXMG6d1UkKqCg1ma931+Z3vG4vd dr56ekgbb@mozmail.com"
      ];
      extraGroups =
        [
          "wheel"
          "users"
          "plugdev"
          "video"
          "audio"
          "git"
          "systemd-journal"
          "input"
          "networkmanager"
          "colord"
        ]
        ++ (builtins.filter (g: config.users.groups ? ${g}) [
          "adbusers"
          "docker"
          "podman"
          "libvirtd"
          "wireshark"
        ]);
      shell = pkgs.bashInteractive;
      packages =
        [ inputs.home-manager.packages.${pkgs.system}.default ]
        ++
        # shell
        (with pkgs; [
          # ouch
          chezmoi
          typst
          ruff
          git-credential-manager
          nodePackages.nodejs
        ])
        ++ (with pkgs; [
          crow-translate
          # zed-editor
          celluloid
          localsend
          popsicle
          alacritty-theme
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
    };
  };

  environment = {
    shells = with pkgs; [
      bashInteractive
      fish
    ];
    variables = {
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      SDL_IM_MODULE = "fcitx";
      GLFW_IM_MODULE = "ibus";
    };
    sessionVariables = {
      EDITOR = "hx";
      MOZ_USE_XINPUT2 = "1";
      LESS = "-SR";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
      SOPS_AGE_RECIPIENTS = "age1n4f3l2tk5qq6snguy5pdl0e7ylyah6ptlrfeyt2pq3whr5edha5q9y0qdu";
    };
    systemPackages =
      (with pkgs; [
        inputs.home-manager.packages.${pkgs.system}.default
        nix-your-shell
        nil
        comma
        nix-tree
        just
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
      ])
      # Python Package
      ++ [
        (pkgs.python3.withPackages (
          ps: with ps; [
            httpx
            python-dotenv
          ]
        ))
      ]
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
                  libGL
                  python3
                  uv
                  gcc
                  poppler_utils
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

  documentation = {
    nixos.enable = false;
    info.enable = false;
    doc.enable = false;
    man = {
      mandoc.enable = true;
      man-db.enable = false;
      generateCaches = false;
    };
  };

  programs = {
    # adb.enable = true;
    ssh = {
      askPassword = "";
      enableAskPassword = false;
    };
    command-not-found.enable = false;
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
    };
    nix-index = {
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
    };
    nix-index-database.comma.enable = true;
    npm.enable = false;
    evolution.enable = false;
    htop = {
      enable = true;
      settings = {
        fields = [
          0
          48
          20
          49
          39
          40
          111
          46
          47
          1
        ];
        hide_userland_threads = 1;
        show_thread_names = 1;
        show_program_path = 0;
        highlight_base_name = 1;
        strip_exe_from_cmdline = 1;
        show_merged_command = 0;
        screen_tabs = 1;
        cpu_count_from_one = 1;
        show_cpu_frequency = 1;
        show_cpu_temperature = 1;
        color_scheme = 6;
        column_meters_0 = [
          "CPU"
          "Memory"
          "Swap"
        ];
        column_meter_modes_0 = [
          1
          1
          1
        ];
        column_meters_1 = [
          "Tasks"
          "DiskIO"
          "NetworkIO"
        ];
        column_meter_modes_1 = [
          2
          2
          2
        ];
        tree_view = 0;
        sort_key = 47;
        sort_direction = -1;
        "screen:Main" = [
          "PID"
          "USER"
          "STARTTIME"
          "TIME"
          "M_RESIDENT"
          "M_SHARE"
          "IO_RATE"
          "PERCENT_CPU"
          "PERCENT_MEM"
          "Command"
        ];
        ".sort_key" = "PERCENT_MEM";
        ".sort_direction" = -1;
      };
    };
    git = {
      enable = true;
      lfs.enable = true;
      config = {
        user = {
          email = "dr56ekgbb@mozmail.com";
          name = "dr56ekgbb";
        };
        core = {
          editor = "hx";
          autocrlf = "input";
          askpass = "";
        };
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        difftool.prompt = false;
        diff.sopsdiffer.textconv = "sops decrypt";
        pager.difftool = true;
        merge.conflictstyle = "diff3";
        credential = {
          credentialStore = "secretservice";
          helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
        };
      };
    };
    # java = {
    #   enable = true;
    #   package = pkgs.jetbrains.jdk;
    # };
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "alacritty";
    };
    xwayland.enable = true;
    bash.promptInit = ''
      PS1='[\u@\h \W]\$ '
    '';
    fish = {
      enable = true;
      interactiveShellInit = ''
        set -U fish_greeting
        nix-your-shell fish | source
      '';
      shellAbbrs = {
        nix-wd = "nix-store --gc --print-roots | rga -v '/proc/' | rga -Po '(?<= -> ).*' | xargs -o nix-tree";
        ezl = "eza -lba --group-directories-first";
        # List all generations of the system profile
        nix-history = "nix profile history --profile /nix/var/nix/profiles/system";
        # remove all generations older than 7 days
        nix-clean = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 1w";
        # Garbage collect all unused nix store entries
        nix-gc = "sudo nix store gc --debug & sudo nix-collect-garbage --delete-old";
      };
    };
    yazi = {
      enable = true;
      settings.yazi.manager = {
        sort_dir_first = true;
        show_hidden = true;
      };
    };
    fzf.fuzzyCompletion = true;
    firefox = {
      enable = true;
      languagePacks = [ "zh-CN" ];
      preferencesStatus = "default";
    };
  };

  qt.enable = true;

  services = {
    # locate = {
    #   enable = true;
    #   interval = "weekly";
    #   package = pkgs.plocate;
    # };
    timesyncd = {
      enable = true;
      extraConfig = ''
        PollIntervalMinSec=4d
        PollIntervalMaxSec=7w
        SaveIntervalSec=infinity
      '';
    };
    avahi.enable = false;
    journald.extraConfig = ''
      ForwardToConsole=no
      ForwardToKMsg=no
      ForwardToSyslog=no
      ForwardToWall=no
      SystemMaxFileSize=10M
      SystemMaxUse=100M
    '';
    irqbalance.enable = true; # 平衡 CPU 负载
    colord.enable = true;
    accounts-daemon.enable = true;
    devmon.enable = true; # 自动设备挂载
    hardware.bolt.enable = false; # Thunderbolt
    geoclue2.enable = false;
    gvfs.enable = true;
    udisks2.enable = true;
    tumbler.enable = true; # 缩略图服务
    dbus = {
      implementation = "broker";
      packages = with pkgs; [
        dconf
        gcr_4
        udisks
      ];
    };
    psd.enable = true;
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
      extraOptions = "--term xterm-256color";
      extraConfig = "font-size=20";
      hwRender = true;
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
    thermald.enable = false;
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
      # package = pkgs.upower-with-conf;
      noPollBatteries = true;
    };
    auto-cpufreq.enable = true; # if config.services.tlp.enable then false else true;
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
      user = "${outputs.vars.users.users.user.username}";
    };
    xserver = {
      enable = true;
      videoDrivers = outputs.vars.services.xserver.videoDrivers;
      desktopManager.xterm.enable = false;
      excludePackages = with pkgs; [ xterm ];
      xkb.model = "pc105";
      wacom.enable = false;
    };
    # flatpak.enable = true;
    # printing.enable = true;
    openssh.enable = false;
  };

  systemd = {
    network.wait-online.enable = false;
    coredump.extraConfig = ''
      Storage=none
      ProcessSizeMax=0
    '';
    sleep.extraConfig = ''
      AllowHibernation=no
    '';
    services = {
      NetworkManager-wait-online.enable = lib.mkForce false;
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
          RemainAfterExit = true;
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
      premiumsoft-reset = {
        script = "${pkgs.bash}/bin/sh -c \"${pkgs.dconf}/bin/dconf reset -f /com/premiumsoft/\"";
        serviceConfig = {
          Type = "oneshot";
          User = "${outputs.vars.users.users.user.username}";
        };
      };
    };
    timers.premiumsoft-reset = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "weekly";
        Persistent = true;
        Unit = "premiumsoft-reset.service";
      };
    };
    user = {
      services = {
        "org.gnome.SettingsDaemon.A11ySettings".enable = false;
        "org.gnome.SettingsDaemon.Sharing".enable = false;
        "org.gnome.SettingsDaemon.Smartcard".enable = false;
        "org.gnome.SettingsDaemon.Wacom".enable = false;
      };
    };
  };

  system.stateVersion = "24.11";
}
