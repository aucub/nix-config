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
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # disable nvidia
    # inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    # Import home-manager's NixOS module
    # inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

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
    options = "--delete-older-than 2d";
  };
  # FIXME: Add the rest of your current configuration

  # TODO: Set your hostname
  networking.hostName = "${vars.hostname}";

  # TODO: This is just an example, be sure to use whatever bootloader you prefer
  # boot.loader.systemd-boot.enable = true;
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
    initrd.kernelModules = ["btrfs"];
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
  };

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = ["zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8"];

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
  hardware.pulseaudio.enable = false;
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
        amdvlk
        vaapiVdpau
        nvidia-vaapi-driver
        libvdpau-va-gl
      ];
    };
    brillo.enable = true;
    bluetooth.enable = true;
    # disable nvidia
    nvidiaOptimus.disable = false;
  };

  users.users.root.initialPassword = "root";
  users.users.root.shell = pkgs.bash;

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    # FIXME: Replace with your username
    "${vars.username}" = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["wheel" "networkmanager" "docker"];
      shell = pkgs.bash;
      packages =
        (with pkgs; [
          inputs.home-manager.packages.${pkgs.system}.default
          vscode
          firefox
          google-chrome
          obs-studio
          localsend
          # postman
          # jetbrains.idea-ultimate
          # bun
          # qq
        ])
        ++ (with pkgs.gnomeExtensions; [
          caffeine
          just-perfection
        ])
        ++ (with pkgs.python311Packages; [
          selenium
          black
        ]);
    };
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [fcitx5-with-addons fcitx5-chinese-addons];
  };

  environment.shells = with pkgs; [bashInteractive fish];

  environment.variables = {
    EDITOR = "helix";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
  };

  environment.sessionVariables = {};

  environment.systemPackages = with pkgs; [
    inputs.home-manager.packages.${pkgs.system}.default
    gnome.adwaita-icon-theme
    gnome.dconf-editor
    gnome.gnome-tweaks
    helix
    git
    eza
    yazi
    fzf
    bat
    fd
    ripgrep-all
    mcfly
    htop
    linux-wifi-hotspot
    python311
    orchis-theme
  ];
  # Ignored Packages
  environment.gnome.excludePackages =
    (with pkgs; [gnome-tour])
    ++ (with pkgs.gnome; [
      atomix
      epiphany
      geary
      gedit
      gnome-characters
      gnome-contacts
      gnome-initial-setup
      hitori
      iagno
      tali
      yelp
    ]);

  documentation = {
    enable = false;
    doc.enable = false;
  };

  programs = {
    command-not-found.enable = false;
    xwayland.enable = true;
    fish = {
      enable = true;
      useBabelfish = true;
      interactiveShellInit = ''
        set -g fish_greeting ""
        ${pkgs.thefuck}/bin/thefuck --alias | source

        # Run function to set colors that are dependant on `$term_background` and to register them so
        # they are triggerd when the relevent event happens or variable changes.
        set-shell-colors

        # Set Fish colors that aren't dependant the `$term_background`.
        set -g fish_color_quote        cyan      # color of commands
        set -g fish_color_redirection  brmagenta # color of IO redirections
        set -g fish_color_end          blue      # color of process separators like ';' and '&'
        set -g fish_color_error        red       # color of potential errors
        set -g fish_color_match        --reverse # color of highlighted matching parenthesis
        set -g fish_color_search_match --background=yellow
        set -g fish_color_selection    --reverse # color of selected text (vi mode)
        set -g fish_color_operator     green     # color of parameter expansion operators like '*' and '~'
        set -g fish_color_escape       red       # color of character escapes like '\n' and and '\x70'
        set -g fish_color_cancel       red       # color of the '^C' indicator on a canceled command
      '';
    };
    fzf.fuzzyCompletion = true;
    firefox = {languagePacks = ["zh-CN"];};
    yazi.settings.yazi = {manager.show_hidden = true;};
  };

  qt = {enable = true;};

  services = {
    auto-cpufreq.enable = true;
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = ["/"];
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
      excludePackages = with pkgs; [];
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
    # CUPS
    # printing.enable = true;
    avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
    flatpak.enable = true;
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
