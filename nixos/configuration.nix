# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  vars,
  ...
}: let
  ifExists = groups:
    builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example
    outputs.nixosModules.yazi
    outputs.nixosModules.fcitx5
    outputs.nixosModules.chromium

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.nixos-hardware.nixosModules.common-cpu-amd
    # inputs.nixos-hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # disable nvidia
    # inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Import home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager

    inputs.nix-index-database.nixosModules.nix-index

    # inputs.stylix.nixosModules.stylix
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs vars outputs;};
    users = {
      # Import your home-manager configuration
      ${vars.username} = import ../home-manager/home.nix;
    };
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      inputs.nur.overlay
      inputs.nix-alien.overlays.default

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry =
    (lib.mapAttrs (_: flake: {inherit flake;}))
    ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs' (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  nix.settings = {
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirrors.bfsu.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
      "https://qihaiumi.cachix.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
    ];
    trusted-public-keys = [
      "qihaiumi.cachix.org-1:0Bt2C1k4MRhqyeUVCOIQJ4O87Wvn5mR0QN7GaNa5AnU="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
    trusted-users = ["root" "@wheel"];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  # FIXME: Add the rest of your current configuration

  networking = {
    hostName = "${vars.hostname}";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  # TODO: This is just an example, be sure to use whatever bootloader you prefer
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
      "acpi_backlight=native"
      "NVreg_PreserveVideoMemoryAllocations=1"
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
      pkgs.linuxKernel.packages.linux_lqx.bbswitch
      pkgs.linuxKernel.packages.linux_lqx.v4l2loopback
    ];
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 video_nr=9 card_label="Virtual Camera"
    '';
    tmp.useTmpfs = true;
    supportedFilesystems = ["btrfs"]; # "bcachefs"
    initrd = {
      supportedFilesystems = ["btrfs"]; # "bcachefs"
      kernelModules = ["btrfs"];
      # services.bcache.enable = true;
    };
  };

  time.timeZone = "Asia/Shanghai";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = ["zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8"];
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [fcitx5-with-addons fcitx5-chinese-addons];
    };
  };

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      sarasa-gothic
      source-han-serif
      source-han-sans
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
        emoji = ["Twemoji" "Noto Color Emoji"];
      };
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [];
  };

  sound.enable = true;

  hardware = {
    pulseaudio.enable = false;
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
        amdvlk
        vaapiVdpau
        nvidia-vaapi-driver
        libvdpau-va-gl
      ];
    };
    brillo.enable = true;
    bluetooth.enable = true;
    nvidiaOptimus.disable = false;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    root = {
      initialPassword = "root";
      shell = pkgs.bashInteractive;
    };
    "${vars.username}" = {
      initialPassword = "${vars.password}";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups =
        ["wheel"]
        ++ ifExists [
          "docker"
          "podman"
          "git"
          "libvirtd"
          "systemd-journal"
          "wireshark"
          "input"
          "networkmanager"
        ];
      shell = pkgs.bashInteractive;
      packages =
        (with pkgs; [inputs.home-manager.packages.${pkgs.system}.default])
        ++ (with inputs.nix-gaming.packages.${pkgs.system}; [
          # wine-ge
        ])
        ++ (with pkgs; [
          vscode
          firefox
          google-chrome
          chromedriver
          impression
          obs-studio
          celluloid
          localsend
          gopeed
          orchis-theme
          typst
          # jetbrains.idea-ultimate
          # jdk21
          # bun
          # qq
        ])
        ++ (with pkgs.gnomeExtensions; [appindicator kimpanel caffeine])
        ++ (with pkgs.python311Packages; [black])
        ++ (with pkgs; [npm-check-updates])
        ++ (with pkgs.nur.repos; [
          # linyinfeng.wemeet
          # xddxdd.dingtalk
          # rewine.ttf-wps-fonts
          # rewine.ttf-ms-win10
          ruixi-rebirth.fcitx5-pinyin-moegirl
          ruixi-rebirth.fcitx5-pinyin-zhwiki
        ]);
    };
  };

  environment.shells = with pkgs; [bashInteractive fish];

  environment.variables = {
    EDITOR = "helix";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
  };

  environment.sessionVariables = {MOZ_USE_XINPUT2 = "1";};

  environment.systemPackages =
    (with pkgs; [
      inputs.home-manager.packages.${pkgs.system}.default
      nix-output-monitor
      nix-alien
    ])
    ++ (with pkgs.gnome; [adwaita-icon-theme dconf-editor gnome-tweaks])
    ++ (with pkgs; [
      difftastic
      helix
      git
      eza
      yazi
      fzf
      bat
      fd
      ripgrep-all
      mcfly
      tlrc
      htop
      linux-wifi-hotspot
      python311
      orchis-theme
    ]);
  # GNOME Ignored Packages
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-tour
      gnome-photos
      gnome-menus
      baobab
      epiphany
      gnome-connections
      libsForQt5.qt5ct
      qt6Packages.qt6ct
    ])
    ++ (with pkgs.gnome; [
      gnome-contacts
      gnome-initial-setup
      yelp
      cheese # webcam tool
      gnome-music
      gnome-terminal
      gedit # text editor
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
    ]);

  documentation = {
    enable = false;
    nixos.enable = false;
    doc.enable = false;
    info.enable = false;
    dev.enable = false;
    man = {
      enable = false;
      man-db.enable = false;
      mandoc.enable = false;
    };
  };

  programs = {
    command-not-found.enable = false;
    nix-ld.enable = true;
    xwayland.enable = true;
    fish = {
      enable = true;
      useBabelfish = true;
      interactiveShellInit = ''
        set -g fish_greeting ""

        set -g fish_key_bindings fish_default_key_bindings

        set -g fish_color_autosuggestion 555\x1ebrblack
        set -g fish_color_cancel \x2dr
        set -g fish_color_command blue
        set -g fish_color_comment red
        set -g fish_color_cwd green
        set -g fish_color_cwd_root red
        set -g fish_color_end green
        set -g fish_color_error brred
        set -g fish_color_escape brcyan
        set -g fish_color_history_current \x2d\x2dbold
        set -g fish_color_host normal
        set -g fish_color_host_remote yellow
        set -g fish_color_normal normal
        set -g fish_color_operator brcyan
        set -g fish_color_param cyan
        set -g fish_color_quote yellow
        set -g fish_color_redirection cyan\x1e\x2d\x2dbold
        set -g fish_color_search_match bryellow\x1e\x2d\x2dbackground\x3dbrblack
        set -g fish_color_selection white\x1e\x2d\x2dbold\x1e\x2d\x2dbackground\x3dbrblack
        set -g fish_color_status red
        set -g fish_color_user brgreen
        set -g fish_color_valid_path \x2d\x2dunderline
        set -g fish_pager_color_completion normal
        set -g fish_pager_color_description B3A06D\x1eyellow\x1e\x2di
        set -g fish_pager_color_prefix normal\x1e\x2d\x2dbold\x1e\x2d\x2dunderline
        set -g fish_pager_color_progress brwhite\x1e\x2d\x2dbackground\x3dcyan
        set -g fish_pager_color_selected_background \x2dr
      '';
    };
    fzf.fuzzyCompletion = true;
    firefox = {
      enable = true;
      languagePacks = ["zh-CN"];
      policies = {
        "DisablePocket" = true;
        "DisableTelemetry" = true;
        "DontCheckDefaultBrowser" = true;
        "HardwareAcceleration" = true;
        "OfferToSaveLoginsDefault" = false;
        "NoDefaultBookmarks" = true;
      };
      preferencesStatus = "default";
      preferences = {
        "media.ffmpeg.vaapi.enabled" = true;
        "gfx.webrender.all" = true;
        "dom.battery.enabled" = false;
        "privacy.trackingprotection.enabled" = true;
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        "browser.safebrowsing.downloads.enabled" = false;
        "font.name.serif.zh-CN" = "Noto Serif CJK SC";
        "font.name.sans-serif.zh-CN" = "更纱黑体 UI SC";
        "font.name.monospace.zh-CN" = "等距更纱黑体 SC";
        "browser.startup.homepage" = "https://limestart.cn/";
        "browser.preferences.moreFromMozilla" = false;
        "extensions.pocket.enabled" = false;
        "network.IDN_show_punycode" = true;
        "browser.newtabpage.pinned" = "";
        "devtools.accessibility.enabled" = false;
      };
    };
  };

  qt = {
    enable = true;
    style = "adwaita";
    platformTheme = "qt5ct";
  };

  services = {
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = ["/"];
    };
    auto-cpufreq.enable = true;
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
      enable = true;
      videoDrivers = ["amdgpu"];
      displayManager = {
        gdm = {enable = true;};
        autoLogin = {
          enable = true;
          user = "${vars.username}";
        };
      };
      desktopManager = {
        xterm.enable = false;
        gnome = {enable = true;};
      };
      excludePackages = with pkgs; [xterm];
      libinput = {
        enable = true;
        mouse = {accelProfile = "adaptive";};
        touchpad = {
          tapping = true;
          naturalScrolling = true;
          accelProfile = "adaptive";
          disableWhileTyping = true;
        };
      };
    };
    udev.packages = with pkgs; [gnome.gnome-settings-daemon];
    flatpak.enable = true;
    # CUPS
    # printing.enable = true;
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = false;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = false;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
