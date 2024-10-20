{
  flake,
  config,
  pkgs,
  ...
}:
let
  inherit (flake) inputs;
in
{
  imports = [
    flake.inputs.nix-index-database.hmModules.nix-index
  ];

  xdg = {
    configFile."nixpkgs/config.nix".text = ''
      {
        allowUnfree = true;
        android_sdk.accept_license = true;
      }
    '';
    configFile."uv/uv.toml".text = ''
      [pip]
      index-url = "https://mirrors.bfsu.edu.cn/pypi/web/simple"
    '';
    configFile."pip/pip.conf".text = ''
      [global]
      index-url = https://mirrors.bfsu.edu.cn/pypi/web/simple
    '';
    configFile."electron-flags.conf".text = ''
      --log-level=0
      --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer
      --ozone-platform-hint=auto
    '';
  };

  programs = {
    man.generateCaches = false;
    nix-index = {
      enableBashIntegration = false;
      enableFishIntegration = false;
    };
    fish = {
      enable = true;
      package = inputs.niqspkgs.packages.${pkgs.system}.fish-git;
      interactiveShellInit =
        ''
          set_proxy
        ''
        + (
          if config.programs.bun.enable then
            ''
              set -x BUN_INSTALL $HOME/.bun
              set -x PATH $PATH $BUN_INSTALL/bin
            ''
          else
            ""
        );
      shellAbbrs.navicat-reset = "${pkgs.dconf}/bin/dconf reset -f /com/premiumsoft/ && ${pkgs.jq}/bin/jq 'with_entries(select(.key | length != 32))' ~/.config/navicat/Premium/preferences.json > ~/.config/navicat/Premium/tmp.json && mv ~/.config/navicat/Premium/tmp.json ~/.config/navicat/Premium/preferences.json";
      functions = {
        nix-loc = "nix-locate $argv | rga -v '\\('";
        nvdd = ''
          if test (count $argv) -ne 2
            echo "Usage: nixos-diff <old_version> <new_version>"
            return 1
          end
          set old_version $argv[1]
          set new_version $argv[2]
          nvd diff /nix/var/nix/profiles/system-$old_version-link /nix/var/nix/profiles/system-$new_version-link
        '';
      };
    };
    tealdeer = {
      enable = false;
      settings = {
        display.compact = true;
        updates.auto_update = false;
      };
    };
    atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        auto_sync = false;
        update_check = false;
        show_help = false;
        enter_accept = true;
        prefers_reduced_motion = true;
      };
    };
    mise = {
      enable = false;
      settings.experimental = true;
    };
    rbw = {
      enable = true;
      settings = {
        pinentry = pkgs.pinentry-gnome3;
        base_url = "https://vault.bitwarden.com/";
        email = "aucub@outlook.com";
      };
    };
    bun = {
      enable = false;
      settings = {
        smol = true;
        telemetry = false;
        install.registry = "https://npmreg.proxy.ustclug.org/";
        run.bun = true;
      };
    };
    broot = {
      enable = true;
      settings.default_flags = "-ih";
    };
    fd = {
      enable = true;
      ignores = [
        ".git/"
        # Dependency directories
        "node_modules/"
        "bower_components/"
        "jspm_packages/"
        # Caches
        ".ipynb_checkpoints/"
        ".cache/"
        ".parcel-cache/"
        ".next/"
        # Python
        ".venv/"
        "__pycache__/"
      ];
    };
    eza = {
      enable = true;
      icons = "auto";
      git = true;
      extraOptions = [
        "--group-directories-first"
        "--all"
      ];
    };
    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "fleet_dark";
        editor = {
          middle-click-paste = false;
          file-picker.hidden = false;
          soft-wrap.enable = true;
          indent-guides.render = true;
        };
      };
    };
    bat = {
      enable = true;
      config = {
        style = "header-filename,header-filesize,grid";
        paging = "never";
        theme = "Dracula";
      };
    };
    git = {
      enable = true;
      package = pkgs.gitFull;
      ignores = [
        # Compiled
        "*.o"
        "*.lo"
        "*.obj"
        "*.elf"
        "*.ilk"
        "*.map"
        "*.exp"
        "*.pdb"
        "*.so"
        "*.dylib"
        "*.dll"
        "*.exe"
        "*.out"
        "*.app"
        "*.i*86"
        "*.x86_64"
        "*.hex"
        "*.apk"
        "*.msi"
        "*.a"
        "*.lib"
        "*.la"
        "*.lai"
        "*.mod"
        "*.smod"
        "*.gch"
        "*.pch"
        "*.d"
        "[Ii]nclude"
        "[Ll]ib"
        "[Ll]ib64"
        "[Ll]ocal"
        # Environments
        ".env"
        ".env.local"
        ".env.*.local"
        # Dependency directories
        "node_modules/"
        "bower_components/"
        "jspm_packages/"
        # IDEs and Editors
        ## JetBrains IDEs
        ".idea/"
        "*.iml"
        ## Eclipse
        ".apt_generated"
        ".classpath"
        ".factorypath"
        ".project"
        ".settings"
        ".springBeans"
        ## NetBeans
        "/nbproject/private/"
        ## Visual Studio Code
        ".vscode/"
        ## SublimeText
        "*.sublime-workspace"
        ## Visual Studio
        ".vs/"
        # Logs and runtime files
        "*.log"
        "*.seed"
        "*.temp"
        # Caches
        ".ipynb_checkpoints/"
        ".cache/"
        ".parcel-cache/"
        ".next/"
        # Operating System
        ".DS_Store"
        # Node
        ".npm"
        ".eslintcache"
        ".stylelintcache"
        "package-lock.json"
        # Python
        ".venv/"
        ".Python"
        "*.py[cod]"
        "__pycache__/"
        "pyvenv.cfg"
        "pip-selfcheck.json"
        # CMake
        "CMakeFiles/"
        "CMakeScripts/"
        "CMakeCache.txt"
        "cmake_install.cmake"
        "CTestTestfile.cmake"
        "*.cmake"
        # Maven
        "pom.xml.tag"
        "pom.xml.releaseBackup"
        "pom.xml.versionsBackup"
        # Databases
        "*.db"
        "*.sqlite3-journal"
        "*.ldf"
        "*.mdf"
        "*.ndf"
        "*.dbmdl"
        # Mobile application development
        "*.ap_"
        "*.dex"
        ".res/"
        ".symbols/"
      ];
      attributes = [
        ".encrypted.* diff=nodiff"
        "*.enc diff=nodiff"
        "*.age diff=nodiff"
      ];
      difftastic = {
        enable = true;
        background = "dark";
        display = "inline";
      };
      hooks.pre-commit = pkgs.writeScript "pre-commit-script" ''
        #!/bin/sh
        gitleaks protect --staged --no-banner --max-target-megabytes 1
      '';
      aliases = {
        ca = "commit --amend --no-edit";
        pf = "push --force";
      };
    };
    alacritty = {
      enable = true;
      settings = {
        general = {
          import = [ "${pkgs.alacritty-theme}/dracula_plus.toml" ];
          live_config_reload = false;
        };
        terminal.shell.program = "fish";
        window = {
          padding = {
            x = 6;
            y = 6;
          };
          dimensions = {
            columns = 120;
            lines = 26;
          };
          startup_mode = "Windowed";
          decorations_theme_variant = "Dark";
        };
        font = {
          normal = {
            family = "Sarasa Mono SC";
            style = "Regular";
          };
          italic = {
            family = "Sarasa Mono Slab SC";
            style = "Italic";
          };
          bold_italic = {
            family = "Sarasa Mono Slab SC";
            style = "Bold Italic";
          };
          size = 20;
        };
        debug = {
          log_level = "Off";
          prefer_egl = true;
        };
        keyboard.bindings = [
          {
            key = "Return";
            mods = "Control|Shift";
            action = "SpawnNewInstance";
          }
        ];
      };
    };
    # obs-studio = {
    #   enable = true;
    #   plugins = with pkgs.obs-studio-plugins; [
    #     obs-pipewire-audio-capture
    #     obs-vaapi
    #     obs-vkcapture
    #   ];
    # };
  };

  manual.manpages.enable = false;

  news.display = "silent";

  systemd.user.startServices = "sd-switch";
}
