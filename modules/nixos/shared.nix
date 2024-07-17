{
  inputs,
  vars,
  lib,
  config,
  pkgs,
  ...
}:
{
  nixpkgs.config.allowUnfree = lib.mkForce true;

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
          # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://numtide.cachix.org" # nixpkgs-unfree
          "https://cache.lix.systems"
          "https://ezkea.cachix.org" # an-anime-game-launcher
          # "https://nixpkgs-wayland.cachix.org"
          # "https://qihaiumi.cachix.org"
          # "https://cosmic.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
          "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
          "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
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
        options = "--delete-older-than 14d";
      };
    };

  networking = {
    hostName = vars.networking.hostName;
    firewall.enable = false;
  };

  time.timeZone = "Asia/Shanghai";

  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    supportedLocales = [
      "zh_CN.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
  };

  users.users = {
    root = {
      initialHashedPassword = vars.users.users.root.initialHashedPassword;
      shell = pkgs.bashInteractive;
    };
    "${vars.users.users.user.username}" = {
      uid = 1000;
      initialHashedPassword = vars.users.users.user.initialHashedPassword;
      isNormalUser = true;
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
        ++ (if config.programs.git.enable || config.home.programs.git.enable then [ "git" ] else [ ])
        ++ (if config.networking.networkmanager.enable then [ "networkmanager" ] else [ ])
        ++ (if config.services.colord.enable then [ "colord" ] else [ ])
        ++ (if config.programs.adb.enable then [ "adbusers" ] else [ ])
        ++ (if config.programs.wireshark.enable then [ "wireshark" ] else [ ])
        ++ (if config.virtualisation.podman.enable then [ "podman" ] else [ ])
        ++ (if config.virtualisation.libvirtd.enable then [ "libvirtd" ] else [ ])
        ++ (if config.virtualisation.docker.enable then [ "docker" ] else [ ]);
      shell = pkgs.bashInteractive;
      packages = [ inputs.home-manager.packages.${pkgs.system}.default ];
    };
  };

  environment = {
    stub-ld.enable = false;
    shells = with pkgs; [
      bashInteractive
      fish
    ];
    sessionVariables = {
      EDITOR = "hx";
      LESS = "-SR";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
      SOPS_AGE_RECIPIENTS = "age1n4f3l2tk5qq6snguy5pdl0e7ylyah6ptlrfeyt2pq3whr5edha5q9y0qdu";
      YAZI_CONFIG_HOME = "/home/${vars.users.users.user.username}/.config/yazi";
    };
    systemPackages = (
      with pkgs;
      [
        inputs.home-manager.packages.${pkgs.system}.default
        nixfmt-rfc-style
        nix-your-shell
        comma
        nix-tree
        just
      ]
    );
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
    ssh = {
      askPassword = ""; # "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
      enableAskPassword = false;
    };
    command-not-found.enable = false;
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
    };
    npm.enable = false;
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
          autocrlf = "input";
          askpass = "";
        };
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        difftool.prompt = false;
        pager.difftool = true;
        merge.conflictstyle = "diff3";
        credential = {
          credentialStore = "secretservice";
          helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
        };
      };
    };
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
        uv-venv = "uv venv --python=${pkgs.python3}/bin/python";
        # List all generations of the system profile
        nix-history = "nix profile history --profile /nix/var/nix/profiles/system";
        # remove all generations older than 7 days
        nix-clean = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d";
        # Garbage collect all unused nix store entries
        nix-gc = "sudo nix store gc & sudo nix-collect-garbage --delete-older-than 7d";
      };
    };
    yazi.enable = true;
  };

  services = {
    avahi.enable = false;
    journald.extraConfig = ''
      ForwardToConsole=no
      ForwardToKMsg=no
      ForwardToSyslog=no
      ForwardToWall=no
      SystemMaxFileSize=10M
      SystemMaxUse=100M
    '';
    dbus.implementation = "broker";
    openssh.enable = false;
  };

  system.stateVersion = "24.11";
}
