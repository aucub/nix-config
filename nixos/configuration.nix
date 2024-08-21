{
  inputs,
  outputs,
  vars,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    outputs.nixosModules.fcitx5
    outputs.nixosModules.chromium
    outputs.nixosModules.gnome
    outputs.nixosModules.steam
    outputs.nixosModules.dae
    outputs.nixosModules.nvidia
    # outputs.nixosModules.containers

    # inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable
    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nix-index-database.nixosModules.nix-index

    ./hardware-configuration.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      inputs.nur.overlay
      inputs.nix-alien.overlays.default
    ];
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      package = pkgs.lix;
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
          "https://nix-community.cachix.org"
          # "https://qihaiumi.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          # "qihaiumi.cachix.org-1:Cf4Vm5/i3794SYj3RYlYxsGQZejcWOwC+X558LLdU6c="
        ];
        trusted-users = [ "@wheel" ];
      };
      channel.enable = false; # nix-channel 命令和状态文件
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
    };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs vars outputs;
    };
    users."${vars.users.users.user.name}" = import ../home-manager/home.nix;
    backupFileExtension = "bak";
  };

  users.users = {
    root = {
      initialHashedPassword = vars.users.users.root.initialHashedPassword;
      shell = pkgs.bashInteractive;
    };
    "${vars.users.users.user.name}" = {
      isNormalUser = true;
      uid = 1000;
      initialHashedPassword = vars.users.users.user.initialHashedPassword;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDk688qD+dBPXh53bQXMG6d1UkKqCg1ma931+Z3vG4vd dr56ekgbb@mozmail.com"
      ];
      extraGroups =
        [
          "wheel"
          "users"
          "plugdev"
          "input"
          "video"
          "audio"
          "systemd-journal"
        ]
        ++ (
          if
            config.programs.git.enable
            || config.home-manager.users."${vars.users.users.user.name}".programs.git.enable
          then
            [ "git" ]
          else
            [ ]
        )
        ++ (if config.networking.networkmanager.enable then [ "networkmanager" ] else [ ])
        ++ (if config.services.colord.enable then [ "colord" ] else [ ])
        ++ (if config.programs.adb.enable then [ "adbusers" ] else [ ])
        ++ (if config.programs.wireshark.enable then [ "wireshark" ] else [ ])
        ++ (if config.virtualisation.podman.enable then [ "podman" ] else [ ])
        ++ (if config.virtualisation.libvirtd.enable then [ "libvirtd" ] else [ ])
        ++ (if config.virtualisation.docker.enable then [ "docker" ] else [ ]);
      shell = pkgs.bashInteractive;
      packages =
        # cli
        (with pkgs; [
          git-credential-manager
          chezmoi
          typst
          ruff
        ])
        ++ (with pkgs; [
          pot
          celluloid
          localsend
          gitkraken
        ])
        # theme
        ++ (with pkgs; [
          alacritty-theme
          (papirus-icon-theme.override { color = "adwaita"; })
          orchis-theme
        ])
        # custom
        ++ (with pkgs; [
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
    variables.EDITOR = "hx";
    sessionVariables = {
      LESS = "-SR";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
      SOPS_AGE_RECIPIENTS = "age1n4f3l2tk5qq6snguy5pdl0e7ylyah6ptlrfeyt2pq3whr5edha5q9y0qdu";
    };
    systemPackages =
      (with pkgs; [
        home-manager
        nixfmt-rfc-style
        comma
        nix-tree
        just
      ])
      ++ (with pkgs; [ nil ])
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
        (pkgs.writeShellScriptBin "patchedpython" ''
          export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
          exec python "$@"
        '')
      ])
      ++ (with pkgs; [ nix-alien ])
      ++ (
        if config.virtualisation.waydroid.enable then
          [ pkgs.nur.repos.ataraxiasjel.waydroid-script ]
        else
          [ ]
      );
  };

  programs = {
    command-not-found.enable = false;
    bash.promptInit = ''
      PS1='[\u@\h \W]\$ '
    '';
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
      '';
      promptInit = ''
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      '';
      shellAbbrs = {
        nix-wd = "nix-store --gc --print-roots | rga -v '/proc/' | rga -Po '(?<= -> ).*' | xargs -o nix-tree";
        ezl = "eza -lba --group-directories-first";
        uv-venv = "uv venv --python=${pkgs.python3}/bin/python";
        # 列出系统的 generations
        nix-history = "nix profile history --profile /nix/var/nix/profiles/system";
        # 删除过期的 generations
        nix-clean = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d";
        # 删除未使用的 Nix 存储条目
        nix-gc = "sudo nix store gc & sudo nix-collect-garbage --delete-older-than 7d";
      };
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        libGL
        glib
      ];
    };
    nix-index = {
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
    };
    nix-index-database.comma.enable = true;
    adb.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
    ssh = {
      askPassword = "";
      enableAskPassword = false;
    };
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
    yazi = {
      enable = true;
      settings.yazi = {
        opener.edit = [
          {
            run = "$\{EDITOR:-hx\} \"$@\"";
            block = true;
            for = "unix";
          }
        ];
        manager = {
          show_hidden = true;
          sort_dir_first = true;
        };
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
          autocrlf = "input";
          askpass = "";
        };
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        difftool.prompt = false;
        credential = {
          credentialStore = "secretservice";
          helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
        };
      };
    };
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

  services = {
    acpid.enable = true;
    upower = {
      enable = true;
      noPollBatteries = true;
    };
    power-profiles-daemon.enable = false;
    tlp.enable = false;
    auto-cpufreq = {
      enable = true;
      settings = {
        charger.governor = "schedutil";
        battery = {
          enable_thresholds = true;
          start_threshold = 70;
          stop_threshold = 75;
        };
      };
    };
    fstrim.enable = if config.fileSystems."/".fsType == "bcachefs" then false else true;
    btrfs.autoScrub.enable = if config.fileSystems."/".fsType == "btrfs" then true else false;
    dbus.implementation = "broker";
    avahi.enable = false;
    geoclue2.enable = false;
    journald.extraConfig = ''
      ForwardToConsole=no
      ForwardToKMsg=no
      ForwardToSyslog=no
      ForwardToWall=no
      SystemMaxFileSize=10M
      SystemMaxUse=100M
    '';
    psd.enable = true;
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
    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    kmscon = {
      enable = true; # 替换 vt
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
    sunshine = {
      enable = true;
      autoStart = false;
      capSysAdmin = true;
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
      user = vars.users.users.user.name;
    };
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      desktopManager.xterm.enable = false;
      excludePackages = with pkgs; [ xterm ];
      wacom.enable = false;
    };
  };

  virtualisation.waydroid.enable = true;

  hardware = {
    enableRedistributableFirmware = true;
    pulseaudio.enable = false;
    graphics.enable = true;
    bluetooth = {
      enable = true;
      settings.General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
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

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  networking = {
    hostName = vars.networking.hostName;
    firewall.enable = false;
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

  time.timeZone = "Asia/Shanghai";

  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    supportedLocales = [
      "zh_CN.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        plasma6Support = true;
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-gtk
          fcitx5-chinese-addons
        ];
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
      removedAssociations = {
        "application/x-zerosize" = "org.gnome.TextEditor.desktop";
        "x-content/unix-software" = "nautilus-autorun-software.desktop";
        "x-scheme-handler/unknown=" = "chromium-browser.desktop";
        "x-scheme-handler/mailto" = "chromium-browser.desktop";
        "x-scheme-handler/webcal" = "chromium-browser.desktop";
        "x-scheme-handler/about" = "chromium-browser.desktop";
        "x-scheme-handler/rlogin" = "ktelnetservice6.desktop";
        "x-scheme-handler/ssh" = "ktelnetservice6.desktop";
        "x-scheme-handler/telnet" = "ktelnetservice6.desktop";
      };
      defaultApplications = {
        "image/jpeg" = "org.gnome.Loupe.desktop";
        "image/png" = "org.gnome.Loupe.desktop";
        "image/gif" = "org.gnome.Loupe.desktop";
        "image/webp" = "org.gnome.Loupe.desktop";
        "image/tiff" = "org.gnome.Loupe.desktop";
        "image/bmp" = "org.gnome.Loupe.desktop";
        "image/vnd-ms.dds" = "org.gnome.Loupe.desktop";
        "image/vnd.microsoft.icon" = "org.gnome.Loupe.desktop";
        "image/vnd.radiance" = "org.gnome.Loupe.desktop";
        "image/x-exr" = "org.gnome.Loupe.desktop";
        "image/x-dds" = "org.gnome.Loupe.desktop";
        "image/x-tga" = "org.gnome.Loupe.desktop";
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
        "text/html" = "firefox.desktop";
        "application/pdf" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/mailto" = "bluetooth-sendto.desktop";
      };
    };
  };

  qt.enable = true;

  systemd = {
    extraConfig = ''
      DefaultTimeoutStopSec=25s
    '';
    coredump.extraConfig = ''
      Storage=none
      ProcessSizeMax=0
    '';
    sleep.extraConfig = ''
      AllowHibernation=no
    '';
    services = {
      systemd-gpt-auto-generator.enable = false;
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
      alsa-store.enable = false;
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

  system.stateVersion = "24.11";
}
