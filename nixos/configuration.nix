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
    outputs.nixosModules.yazi
    outputs.nixosModules.fcitx5
    outputs.nixosModules.chromium

    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable

    ./hardware-configuration.nix

    inputs.home-manager.nixosModules.home-manager

    inputs.nix-index-database.nixosModules.nix-index
    inputs.chaotic.nixosModules.default
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
      outputs.overlays.unstable-packages
      inputs.nur.overlay
    ];
    config = {
      allowUnfree = true;
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
      substituters = [
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://qihaiumi.cachix.org"
        "https://cosmic.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "qihaiumi.cachix.org-1:Cf4Vm5/i3794SYj3RYlYxsGQZejcWOwC+X558LLdU6c="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
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
    networkmanager.enable = true;
    firewall.enable = false;
    networkmanager.dns = "systemd-resolved";
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      systemd-boot = {
        enable = true;
        graceful = true;
        configurationLimit = 10;
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
      "acpi_backlight=native"
      "NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia_drm.fbdev=1"
    ];
    consoleLogLevel = 3;
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
      options v4l2loopback exclusive_caps=1 video_nr=9 card_label="Virtual Camera"
    '';
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
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "zh_CN.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_TIME = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
    };
    inputMethod = {
      enabled = "fcitx5";
      fcitx5 = {
        plasma6Support = true;
        addons = with pkgs; [
          fcitx5-gtk
          libsForQt5.fcitx5-with-addons
          libsForQt5.fcitx5-chinese-addons
        ];
        waylandFrontend = true;
      };
    };
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      sarasa-gothic
      source-han-mono
      source-han-serif-vf-otf
      source-han-sans-vf-otf
      twitter-color-emoji
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Noto Serif CJK SC"];
        sansSerif = ["Sarasa UI SC"];
        monospace = ["Sarasa Mono SC"];
        emoji = [
          "Twemoji"
          "Noto Color Emoji"
        ];
      };
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  sound.enable = true;

  hardware = {
    pulseaudio.enable = false;
    # nvidia = {
    #   open = true;
    #   modesetting.enable = true;
    #   dynamicBoost.enable = true;
    #   prime.sync.enable = true;
    #   package = pkgs.linuxKernel.packages.linux_zen.nvidia_x11_vulkan_beta_open;
    #   powerManagement = {
    #     enable = true;
    #     finegrained = true;
    #   };
    #   prime = {
    #     offload = {
    #       enable = true;
    #       enableOffloadCmd = true;
    #     };
    #   };
    # };
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [
        amdvlk
        vaapiVdpau
        nvidia-vaapi-driver
        libvdpau-va-gl
      ];
    };
    # 允许视频组中的用户进行亮度控制
    brillo.enable = true;
    bluetooth.enable = true;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  users.users = {
    root = {
      hashedPassword = "${vars.users.users.root.hashedPassword}";
      shell = pkgs.bashInteractive;
    };
    "${vars.users.users.username}" = {
      hashedPassword = "${vars.users.users.hashedPassword}";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDk688qD+dBPXh53bQXMG6d1UkKqCg1ma931+Z3vG4vd dr56ekgbb@mozmail.com"
      ];
      extraGroups =
        ["wheel"]
        ++ (builtins.filter (g: config.users.groups ? ${g}) [
          "docker"
          "podman"
          "git"
          "libvirtd"
          "systemd-journal"
          "wireshark"
          "input"
          "networkmanager"
        ]);
      shell = pkgs.bashInteractive;
      packages =
        (with pkgs; [inputs.home-manager.packages.${pkgs.system}.default])
        ++
        # shell
        (with pkgs; [
          atuin
          typst
          uv
          ruff
          git-credential-manager
          bun
          # nodejs_20
        ])
        ++ (with pkgs; [
          vscode
          firefox
          celluloid
          localsend
          chromium
          localsend
          wofi
          impression
          # obs-studio
          # nomacs
          # jetbrains.idea-ultimate
        ])
        # theme
        ++ (with pkgs; [
          papirus-folders
          papirus-icon-theme
          bibata-cursors
        ])
        # gnomeExtensions
        ++ (with pkgs.gnomeExtensions; [
          appindicator
          caffeine
          kimpanel
        ])
        # custom
        ++ (with pkgs; [
          hiddify-next
          gopeed
          orchis-theme
        ])
        ++ (with pkgs.nur.repos; [ruixi-rebirth.fcitx5-pinyin-zhwiki]);
    };
  };

  environment = {
    shells = with pkgs; [
      bashInteractive
      fish
    ];
    variables = {
      EDITOR = "helix";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      SDL_IM_MODULE = "fcitx";
      GLFW_IM_MODULE = "ibus";
    };
    systemPackages =
      (with pkgs; [
        inputs.home-manager.packages.${pkgs.system}.default
        nix-output-monitor
        comma
      ])
      ++ (with pkgs; [
        alacritty
        difftastic
        helix
        delta
        git
        eza
        yazi
        fzf
        bat
        fd
        ripgrep-all
        tlrc
        typos
        htop
        python3
        lnav
        uutils-coreutils-noprefix
        android-tools
      ]);
    gnome.excludePackages =
      (with pkgs; [
        gnome-tecla
        gnome-tour
        gnome-photos
        gnome-menus
        baobab
        epiphany
        gnome-connections
        libsForQt5.qt5ct
        qt6Packages.qt6ct
        gnome-console
      ])
      ++ (with pkgs.gnome; [
        gnome-contacts
        gnome-initial-setup
        yelp
        cheese # webcam tool
        gnome-music
        gnome-terminal
        epiphany # web browser
        geary # email reader
        gnome-calendar
        gnome-clocks
        gnome-characters
        gnome-maps
        gnome-weather
        gnome-software
        simple-scan
        totem # video player
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
        file-roller
        seahorse
      ]);
  };

  documentation = {
    nixos.enable = false;
  };

  programs = {
    command-not-found.enable = false;
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
          editor = "helix";
          autocrlf = "input";
          pager = "delta";
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
        ezl = "eza -lba --group-directories-first";
      };
    };
    fzf.fuzzyCompletion = true;
    firefox = {
      enable = true;
      languagePacks = ["zh-CN"];
      preferencesStatus = "default";
    };
    seahorse.enable = false;
    gnome-terminal.enable = false;
    file-roller.enable = false;
  };

  qt = {
    enable = true;
    style = "adwaita";
    platformTheme = "gnome";
  };

  services = {
    gnome = {
      gnome-user-share.enable = false;
      gnome-online-accounts.enable = false;
      gnome-browser-connector.enable = false;
      games.enable = false;
      tracker.enable = false;
      tracker-miners.enable = false;
      rygel.enable = false;
      gnome-remote-desktop.enable = false;
      evolution-data-server.enable = lib.mkForce false;
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
      displayManager.gdm = {
        enable = true;
        settings.daemon = {
          AutomaticLoginEnable = true;
          AutomaticLogin = "${vars.users.users.username}";
        };
      };
      videoDrivers = [
        "amdgpu"
      ];
      desktopManager = {
        xterm.enable = false;
        gnome = {
          enable = true;
        };
      };
      excludePackages = with pkgs; [xterm];
    };
    # flatpak.enable = true;
    # printing.enable = true;
  };

  services.openssh = {
    enable = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  system.stateVersion = "24.05";
}
