{
  flake,
  pkgs,
  ...
}:
let
  inherit (flake) inputs;
in
{
  programs = {
    auto-cpufreq = {
      enable = true;
      settings.charger = {
        governor = "schedutil";
        turbo = "auto";
      };
    };
    command-not-found.enable = false;
    bash.promptInit = ''
      PS1='\u@\h\[\e[32m\]\w\[\e[0m\] \\$ '
    '';
    fish = {
      enable = true;
      package = inputs.niqspkgs.packages.${pkgs.system}.fish-git;
      interactiveShellInit = ''
        set fish_greeting
        set -U fish_history_max 2500
        set -gx fish_prompt_pwd_dir_length 0
        fish_config theme choose 'Tomorrow Night Bright'
        fish_config prompt choose simple
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      '';
      shellAbbrs = {
        nix-wd = "nix-store --gc --print-roots | rga -v '/proc/' | rga -Po '(?<= -> ).*' | xargs -o nix-tree";
        ezl = "eza -lba --group-directories-first";
        uv-venv = "uv venv --python=${pkgs.python3}/bin/python";
        # 列出系统的 generations
        nix-history = "nix profile history --profile /nix/var/nix/profiles/system";
        # 删除过期的 generations
        nix-clean = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system && home-manager expire-generations 0days";
        # 删除未使用的 Nix 存储条目
        nix-gc = "sudo nix-collect-garbage --delete-older-than 7d && nix-collect-garbage --delete-older-than 7d";
        sopsb = "env SOPS_AGE_KEY=(rbw get age) sops";
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
    git = {
      enable = true;
      package = pkgs.gitFull;
      lfs.enable = true;
      config = {
        user = {
          email = "dr56ekgbb@mozmail.com";
          name = "dr56ekgbb";
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
        credential.credentialStore = "secretservice";
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
    man.generateCaches = false;
  };
}
