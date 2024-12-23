{
  flake,
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (flake) inputs;
  inherit (inputs) self;
  hostname = "neko";
  defaultUserName = flake.config.hosts."${hostname}".defaultUserName;
  defaultUser = flake.config.users."${defaultUserName}";
  defaultUserUid = flake.config.users."${defaultUserName}".uid;
in
{
  imports =
    [
      inputs.nix-index-database.nixosModules.nix-index
    ]
    ++ [
      inputs.nixos-hardware.nixosModules.common-cpu-amd
      inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
      inputs.nixos-hardware.nixosModules.common-pc-laptop
      inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
      ./hardware-configuration.nix
    ]
    ++ [
      self.nixosModules.dae
      self.nixosModules.gnome
      self.nixosModules.fcitx5
      self.nixosModules.chromium
      self.nixosModules.nvidia
      self.nixosModules.steam
    ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      self.overlays.default
      inputs.nur.overlays.default
      inputs.nix-alien.overlays.default
      inputs.nix-vscode-extensions.overlays.default
    ];
  };

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
    kernelPackages = pkgs.linuxPackages_testing;
    kernelParams = [
      "amdgpu.vm_update_mode=3"
      "radeon.dpm=0"
      "acpi_backlight=native"
      "mitigations=off" # 关闭漏洞缓解措施提高
      "nowatchdog" # PC不需要watchdog
    ];
    kernelModules = [
      # "v4l2loopback"
      "amdgpu"
    ];
    extraModulePackages = (
      with config.boot.kernelPackages;
      [
        # kernelPackages.lenovo-legion-module
        # v4l2loopback
      ]
    );
    extraModprobeConfig = ''
      blacklist sp5100_tco
      blacklist iTCO_wdt
      options nvidia "NVreg_EnableGpuFirmware=0"
    ''
    # + ''
    #   options v4l2loopback devices=1 video_nr=1 card_label="Virtual Camera" exclusive_caps=1
    # ''
    ;
    consoleLogLevel = 3;
    tmp.useTmpfs = true;
    supportedFilesystems = [ config.fileSystems."/".fsType ];
  };

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  networking = {
    hostName = hostname;
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

  home-manager = {
    users."${defaultUserName}" = {
      imports = [ (self + /configurations/home/${defaultUserName}.nix) ];
    };
    backupFileExtension = "bak";
  };

  users.users = {
    root = {
      initialHashedPassword = flake.config.users.root.initialHashedPassword;
      shell = pkgs.bashInteractive;
    };
    "${defaultUserName}" = {
      isNormalUser = true;
      uid = defaultUser.uid;
      initialHashedPassword = defaultUser.initialHashedPassword;
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
        ++ (lib.optional (
          config.programs.git.enable || config.home-manager.users."${defaultUser}".programs.git.enable
        ) "git")
        ++ (lib.optional config.networking.networkmanager.enable "networkmanager")
        ++ (lib.optional config.services.colord.enable "colord")
        ++ (lib.optional config.programs.adb.enable "adbusers")
        ++ (lib.optional config.programs.wireshark.enable "wireshark")
        ++ (lib.optional config.virtualisation.podman.enable "podman")
        ++ (lib.optional config.virtualisation.libvirtd.enable "libvirtd")
        ++ (lib.optional config.virtualisation.docker.enable "docker");
      shell = pkgs.bashInteractive;
      packages =
        # cli
        (with pkgs; [
          typst
          ruff
        ])
        ++ (with pkgs; [
          variety
          sly
          celluloid
          pot
          telegram-desktop
          # gitkraken
        ])
        # theme
        ++ (with pkgs; [
          alacritty-theme
          (papirus-icon-theme.override { color = "adwaita"; })
          orchis-theme
        ])
        # custom
        ++ (with pkgs; [
          navicat-premium
        ]);
    };
  };

  environment = {
    stub-ld.enable = false;
    shells = with pkgs; [
      bashInteractive
      fish
    ];
    variables = {
      NIX_REMOTE = "daemon";
      EDITOR = "hx";
      __EGL_VENDOR_LIBRARY_FILENAMES = "${pkgs.mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json";
      __GLX_VENDOR_LIBRARY_NAME = "mesa";
    };
    sessionVariables = {
      LESS = "-SR";
      MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
      MANROFFOPT = "-c";
      SOPS_AGE_RECIPIENTS = "age1n4f3l2tk5qq6snguy5pdl0e7ylyah6ptlrfeyt2pq3whr5edha5q9y0qdu";
    };
    systemPackages =
      (with pkgs; [
        home-manager
        nixos-rebuild-ng
        nixfmt-rfc-style
        comma
        nix-tree
        nvd
        go-task
      ])
      ++ (with pkgs; [
        nil
      ])
      ++ (with pkgs; [
        difftastic
        sops
        helix
        gitleaks
        eza
        fzf
        fd
        ripgrep
        ripgrep-all
        typos
        lnav
        uutils-coreutils-noprefix
        # nvtopPackages.amd
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
      ++ (with pkgs; [ nix-alien ]);
  };

  nix = {
    package = pkgs.nixVersions.latest;
    daemonIOSchedClass = lib.mkDefault "idle";
    daemonCPUSchedPolicy = lib.mkDefault "idle";
    settings = {
      flake-registry = "";
      experimental-features = [
        "nix-command"
        "flakes"
        "cgroups"
        "ca-derivations"
        "git-hashing"
        "dynamic-derivations"
      ];
      auto-optimise-store = true;
      always-allow-substitutes = true;
      builders-use-substitutes = true;
      use-cgroups = true;
      warn-dirty = false;
      fsync-metadata = false;
      substituters = [
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
        "https://cache.garnix.io"
        "https://nanari.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "nanari.cachix.org-1:g2X+SmJHsI0siZez0IUUgVyOuvPG5CWhrhoE11MqALA="
      ];
      trusted-users = [ "@wheel" ];
    };
    channel.enable = false;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  time.timeZone = "Asia/Singapore";

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
      nerd-fonts.symbols-only
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
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-gtk
          libsForQt5.fcitx5-chinese-addons
        ];
      };
    };
  };

  programs = {
    command-not-found.enable = false;
    bash.promptInit = ''
      PS1='\u@\h\[\e[32m\]\w\[\e[0m\] \\$ '
    '';
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
        set -U fish_history_max 2500
        set -gx fish_prompt_pwd_dir_length 0
        fish_config theme choose 'Tomorrow Night Bright'
        fish_config prompt choose simple
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      '';
      shellAbbrs = {
        nix-wd = "nix-store --gc --print-roots | rg -v '/proc/' | rg -Po '(?<= -> ).*' | xargs -o nix-tree";
        ezl = "eza -lba --group-directories-first";
        uv-venv = "uv venv --python=${pkgs.python3}/bin/python";
        # 列出系统的 generations
        nix-history = "nix profile history --profile /nix/var/nix/profiles/system";
        # 删除过期的 generations
        nix-clean = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system && home-manager expire-generations 0days";
        # 删除未使用的 Nix 存储条目
        nix-gc = "sudo nix-collect-garbage --delete-older-than 7d && nix-collect-garbage --delete-older-than 7d";
        sopsb = "env SOPS_AGE_KEY=(${pkgs.bitwarden-cli}/bin/bw get password age) sops";
      };
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        glib
        libGL
      ];
    };
    nix-index = {
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
    };
    nix-index-database.comma.enable = true;
    adb.enable = true;
    # appimage = {
    #   enable = true;
    #   binfmt = true;
    # };
    direnv.enable = true;
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
    bat = {
      enable = true;
      settings = {
        style = "header-filename,header-filesize,grid";
        paging = "never";
        theme = "Dracula";
      };
    };
    git = {
      enable = true;
      package = pkgs.gitFull;
      lfs.enable = true;
      config = {
        user = {
          name = "aucub";
          email = "<>";
        };
        core = {
          autocrlf = "input";
          askpass = "";
          quotepath = false;
        };
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        difftool.prompt = false;
        diff.nodiff.command = "${pkgs.uutils-coreutils-noprefix}/bin/true";
        rebase.autosquash = true;
        log.date = "iso";
        merge.conflictStyle = "diff3";
        credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
      };
    };
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "alacritty";
    };
    localsend.enable = true;
  };

  xdg = {
    terminal-exec.enable = true;
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };

  security.sudo-rs.enable = true;

  documentation = {
    nixos.enable = false;
    info.enable = false;
    doc.enable = false;
    man = {
      man-db.enable = false;
      mandoc.enable = true;
      generateCaches = false;
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
      settings.charger = {
        governor = "schedutil";
        turbo = "auto";
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
      enable = true;
      fonts = [
        {
          name = "Sarasa Mono SC";
          package = pkgs.sarasa-gothic;
        }
      ];
      extraConfig = "font-size=20";
      hwRender = true;
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
      user = defaultUserName;
    };
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      desktopManager.xterm.enable = false;
      excludePackages = with pkgs; [ xterm ];
      wacom.enable = false;
    };
    # flatpak.enable = true;
  };

  systemd = {
    extraConfig = ''
      DefaultTimeoutStopSec=25s
      DefaultTimeoutAbortSec=25s
    '';
    sleep.extraConfig = "AllowHibernation=no";
    timers.suspend-then-shutdown = {
      wantedBy = [ "sleep.target" ];
      partOf = [ "sleep.target" ];
      onSuccess = [ "suspend-then-shutdown.service" ];
      timerConfig = {
        OnActiveSec = "2h";
        AccuracySec = "30m";
        RemainAfterElapse = false;
        WakeSystem = true;
      };
    };
    services = {
      nix-daemon.serviceConfig.Slice = "-.slice";
      suspend-then-shutdown = {
        description = "Shutdown after suspend";
        path = with pkgs; [ dbus ];
        environment = {
          DISPLAY = ":0";
          DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/${toString defaultUserUid}/bus";
          XDG_RUNTIME_DIR = "/run/user/${toString defaultUserUid}";
        };
        script = ''
          sleep 1m
          current_timestamp=$(${pkgs.coreutils}/bin/date +%s)
          active_enter_timestamp=$(${pkgs.coreutils}/bin/date -d "$(systemctl show -p ActiveEnterTimestamp sleep.target | cut -d= -f2)" +%s)
          if [ $((current_timestamp - active_enter_timestamp)) -ge 6000 ]; then
            ${pkgs.gnome-session}/bin/gnome-session-quit --power-off
          fi
        '';
        serviceConfig = {
          Type = "simple";
          User = defaultUserUid;
        };
      };
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

  system = {
    rebuild.enableNg = true;
    stateVersion = lib.trivial.release;
  };
}
