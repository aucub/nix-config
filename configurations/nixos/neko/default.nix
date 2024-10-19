{
  flake,
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
in
{
  imports =
    [
      inputs.nixos-hardware.nixosModules.common-cpu-amd
      inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
      inputs.nixos-hardware.nixosModules.common-pc-laptop
      inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
      ./hardware-configuration.nix
    ]
    ++ [
      self.nixosModules.shell
      self.nixosModules.gui
    ]
    ++ [
      inputs.nix-index-database.nixosModules.nix-index
      inputs.auto-cpufreq.nixosModules.default
    ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      self.overlays.default
      inputs.nur.overlay
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
    kernelPackages =
      (import inputs.nixpkgs-unstable-small {
        system = pkgs.system;
      }).linuxPackages_zen;
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
        ++ (
          if config.programs.git.enable || config.home-manager.users."${defaultUser}".programs.git.enable then
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
          damask
          warp-plus
        ]);
    };
  };

  environment = {
    stub-ld.enable = false;
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
        nvd
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

  system.stateVersion = "24.11";
}
