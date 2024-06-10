{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  vars,
  ...
}: {
  imports = [
    outputs.nixosModules.fcitx5
    outputs.nixosModules.chromium
    outputs.nixosModules.gnome
    outputs.nixosModules.nvidia-disable

    ./hardware-configuration.nix

    inputs.home-manager.nixosModules.home-manager

    inputs.nix-index-database.nixosModules.nix-index
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs vars outputs;
    };
    users = {
      "${vars.users.users.username}" = import ../home-manager/home.nix;
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

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
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

    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  networking = {
    hostName = "${vars.hostname}";
    firewall.enable = false;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi = {
        backend = "iwd";
        powersave = false;
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
        configurationLimit = 15;
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
    blacklistedKernelModules = ["nouveau"];
    extraModulePackages = vars.boot.extraModulePackages pkgs;
    extraModprobeConfig = vars.boot.extraModprobeConfig;
    tmp.useTmpfs = true;
    supportedFilesystems = [
      "btrfs"
      "bcachefs"
    ];
    initrd = {
      supportedFilesystems = [
        "btrfs"
        "bcachefs"
      ];
      kernelModules = [
        "btrfs"
        "bcachefs"
      ];
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
        serif = ["Noto Serif CJK SC" "Noto Color Emoji"];
        sansSerif = ["Sarasa UI SC" "Noto Color Emoji"];
        monospace = ["Sarasa Mono SC" "Noto Color Emoji"];
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
      addedAssociations = {
        "text/plain" = "dev.zed.Zed.desktop";
      };
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
    wirelessRegulatoryDatabase = lib.mkDefault false;
    firmware = with pkgs; [
      linux-firmware
    ];
    pulseaudio.enable = false;
    acpilight.enable = false;
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = vars.hardware.opengl.extraPackages pkgs;
    };
    # 允许视频组中的用户进行亮度控制
    brillo.enable = true;
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
      initialHashedPassword = "${vars.users.users.root.initialHashedPassword}";
      shell = pkgs.bashInteractive;
    };
    "${vars.users.users.username}" = {
      uid = 1000;
      initialHashedPassword = "${vars.users.users.initialHashedPassword}";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDk688qD+dBPXh53bQXMG6d1UkKqCg1ma931+Z3vG4vd dr56ekgbb@mozmail.com"
      ];
      extraGroups = [
        "wheel"
        "users"
        "plugdev"
        "video"
        "audio"
        "docker"
        "podman"
        "git"
        "libvirtd"
        "systemd-journal"
        "wireshark"
        "input"
        "networkmanager"
        "colord"
        "adbusers"
      ];
      shell = pkgs.bashInteractive;
      packages =
        [
          inputs.home-manager.packages.${pkgs.system}.default
        ]
        ++
        # shell
        (with pkgs; [
          chezmoi
          typst
          uv
          ruff
          git-credential-manager
          nodePackages.nodejs
        ])
        ++ (with pkgs; [
          zed-editor
          celluloid
          localsend
          impression
          # nomacs
          # jetbrains.idea-ultimate
        ])
        # theme
        ++ (with pkgs; [
          (papirus-icon-theme.override
            {color = "adwaita";})
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
      EDITOR = "hx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      SDL_IM_MODULE = "fcitx";
      GLFW_IM_MODULE = "ibus";
    };
    systemPackages =
      (with pkgs; [
        inputs.home-manager.packages.${pkgs.system}.default
        nil
        comma
        nix-tree
        just
      ])
      ++ (with pkgs; [
        difftastic
        helix
        delta
        gitleaks
        eza
        lnav
        fzf
        bat
        fd
        ripgrep-all
        typos
        python3Full
        lnav
        uutils-coreutils-noprefix
        # android-tools
      ])
      # FHS
      ++ (with pkgs; [
        (
          let
            base = pkgs.appimageTools.defaultFhsEnvArgs;
          in
            pkgs.buildFHSUserEnv (base
              // {
                name = "fhs";
                targetPkgs = pkgs:
                  (base.targetPkgs pkgs)
                  ++ (with pkgs; [
                    pkg-config
                  ]);
                profile = "export FHS=1";
                runScript = "fish";
                extraOutputsToInstall = ["dev"];
              })
        )
        (
          let
            base = pkgs.appimageTools.defaultFhsEnvArgs;
          in
            pkgs.buildFHSUserEnv (base
              // {
                name = "pipzone";
                targetPkgs = pkgs:
                  (base.targetPkgs pkgs)
                  ++ (with pkgs; [
                    pkg-config
                    libGL
                    glib
                    libgcc
                    gccStdenv
                    python3Full
                    uv
                  ])
                  ++ [
                    (pkgs.python3.withPackages (subpkgs:
                      with subpkgs; [
                        pip
                        virtualenv
                      ]))
                  ];
                profile = "export FHS=1";
                runScript = "fish";
                extraOutputsToInstall = ["dev"];
                extraBindMounts = [
                  {
                    from = "/etc/gitconfig";
                    to = "/etc/gitconfig";
                  }
                ];
              })
        )
      ])
      ++ (
        if config.services.xserver.desktopManager.gnome.enable
        then
          # gnomeExtensions
          (with pkgs.gnomeExtensions; [
            appindicator
            caffeine
            kimpanel
          ])
          # gnome
          ++ (with pkgs.gnome; [
            dconf-editor
            gnome-tweaks
          ])
          ++ (with pkgs; [
            gtop
          ])
        else []
      );
  };

  documentation = {
    nixos.enable = false;
    man.generateCaches = false;
  };

  programs = {
    ssh.enableAskPassword = false;
    command-not-found.enable = false;
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
    npm.enable = false;
    htop = {
      enable = true;
      settings = {
        fields = [
          0
          48
          17
          18
          38
          39
          40
          2
          46
          47
          49
          1
        ];
        hide_kernel_threads = true;
        hide_userland_threads = true;
        hide_running_in_container = false;
        shadow_other_users = false;
        show_thread_names = false;
        show_program_path = true;
        highlight_base_name = true;
        highlight_deleted_exe = true;
        shadow_distribution_path_prefix = false;
        highlight_megabytes = true;
        highlight_threads = true;
        highlight_changes = false;
        highlight_changes_delay_secs = 5;
        find_comm_in_cmdline = true;
        strip_exe_from_cmdline = true;
        show_merged_command = false;
        header_margin = 1;
        screen_tabs = true;
        detailed_cpu_time = false;
        cpu_count_from_one = false;
        show_cpu_usage = true;
        show_cpu_frequency = true;
        show_cpu_temperature = true;
        degree_fahrenheit = false;
        update_process_names = false;
        account_guest_in_cpu_meter = false;
        color_scheme = 6;
        enable_mouse = true;
        delay = 15;
        hide_function_bar = false;
        header_layout = "two_50_50";
        column_meters_0 = "LeftCPUs2 Memory Swap";
        column_meter_modes_0 = [
          1
          1
          1
        ];
        column_meters_1 = "RightCPUs2 Tasks LoadAverage Uptime";
        column_meter_modes_1 = [
          1
          2
          2
          2
        ];
        screen_Main = "PID USER PRIORITY NICE M_VIRT M_RESIDENT M_SHARE STATE PERCENT_CPU PERCENT_MEM TIME Command";
        screen_Main_sort_key = "PERCENT_MEM";
        screen_Main_tree_sort_key = "PID";
        screen_Main_tree_view_always_by_pid = false;
        screen_Main_tree_view = false;
        screen_Main_sort_direction = -1;
        screen_Main_tree_sort_direction = 1;
        screen_Main_all_branches_collapsed = false;
        screen_IO = "PID USER IO_PRIORITY IO_RATE IO_READ_RATE IO_WRITE_RATE PERCENT_SWAP_DELAY PERCENT_IO_DELAY Command";
        screen_IO_sort_key = "IO_RATE";
        screen_IO_tree_sort_key = "PID";
        screen_IO_tree_view_always_by_pid = false;
        screen_IO_tree_view = false;
        screen_IO_sort_direction = -1;
        screen_IO_tree_sort_direction = 1;
        screen_IO_all_branches_collapsed = false;
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
          pager = "delta";
          askpass = "";
        };
        init = {
          defaultBranch = "main";
        };
        push = {
          autoSetupRemote = true;
        };
        diff = {
          tool = "difftastic";
          colorMoved = "default";
        };
        difftool = {
          prompt = false;
          difftastic = {
            cmd = "difft \"$LOCAL\" \"$REMOTE\"";
          };
        };
        pager = {
          difftool = true;
        };
        interactive = {
          diffFilter = "delta --color-only";
        };
        delta = {
          navigate = true;
        };
        merge = {
          conflictstyle = "diff3";
        };
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
    nix-ld.enable = true;
    xwayland.enable = true;
    fish = {
      enable = true;
      interactiveShellInit = ''
        set -U fish_greeting
      '';
      shellAbbrs = {
        nix-wd = "nix-store --gc --print-roots | rga -v '/proc/' | rga -Po '(?<= -> ).*' | xargs -o nix-tree";
        ezl = "eza -lba --group-directories-first";
        # List all generations of the system profile
        nix-history = "nix profile history --profile /nix/var/nix/profiles/system";
        # remove all generations older than 7 days
        nix-clean = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d";
        # Garbage collect all unused nix store entries
        nix-gc = "sudo nix store gc --debug & sudo nix-collect-garbage --delete-old";
      };
    };
    yazi = {
      enable = true;
      settings.yazi = {
        manager = {
          sort_dir_first = true;
          show_hidden = true;
        };
      };
    };
    fzf.fuzzyCompletion = true;
    firefox = {
      enable = true;
      languagePacks = ["zh-CN"];
      preferencesStatus = "default";
    };
  };

  qt.enable = true;

  services = {
    timesyncd.enable = true;
    avahi.enable = false;
    journald.extraConfig = "SystemMaxUse=50M\nSystemMaxFiles=5";
    cron = {
      enable = true;
      systemCronJobs = [
        "0 0 * * 0  navicat   dconf reset -f com/premiumsoft/navicat-premium"
      ];
    };
    colord.enable = true;
    accounts-daemon.enable = true;
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    tumbler.enable = true;
    udev = {
      packages = with pkgs; [
        gnome.gnome-settings-daemon
        android-udev-rules
      ];
    };
    dbus = {
      implementation = "broker";
      packages = with pkgs; [dconf gcr udisks2];
    };
    psd.enable = true;
    fstrim.enable = true;
    kmscon = {
      # Instead of vt
      enable = true;
      fonts = [
        {
          name = "Source Code Pro";
          package = pkgs.source-code-pro;
        }
      ];
      extraOptions = "--term xterm-256color";
      extraConfig = "font-size=14";
      hwRender = true;
    };
    resolved = {
      enable = true;
      dnsovertls = "true";
      extraConfig = ''
        [Resolve]
        DNS=223.5.5.5#dns.alidns.com 8.8.8.8#dns.google 1.0.0.1 2400:3200::1 2606:4700:4700::1001
        DNSOverTLS=yes
        Domains=~.
      '';
    };
    # 温控
    thermald.enable = lib.mkDefault true;
    acpid.enable = true;
    # btrfs.autoScrub = {
    # enable = true;
    # };
    power-profiles-daemon.enable = true;
    upower = {
      enable = true;
      noPollBatteries = true;
    };
    auto-cpufreq.enable = true;
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
      mouse = {
        accelProfile = "adaptive";
      };
      touchpad = {
        tapping = true;
        naturalScrolling = true;
        accelProfile = "adaptive";
        disableWhileTyping = true;
      };
    };
    displayManager = {
      autoLogin = {
        enable = true;
        user = "${vars.users.users.username}";
      };
    };
    xserver = {
      enable = true;
      videoDrivers = [
        "modesetting"
        "fbdev"
        "amdgpu"
      ];
      desktopManager.xterm.enable = false;
      excludePackages = with pkgs; [xterm];
    };
    # flatpak.enable = true;
    # printing.enable = true;
    openssh.enable = false;
  };

  systemd = {
    network.wait-online.enable = false;
    services = {
      NetworkManager-wait-online.enable = lib.mkForce false;
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };
  };

  system.stateVersion = "24.11";
}
