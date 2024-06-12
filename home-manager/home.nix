{
  inputs,
  outputs,
  pkgs,
  vars,
  ...
}: {
  imports = [
    outputs.homeManagerModules.dotfiles
    outputs.homeManagerModules.firefox
    outputs.homeManagerModules.vscode
    outputs.homeManagerModules.dconf
    outputs.homeManagerModules.chromium
    outputs.homeManagerModules.wofi
    outputs.homeManagerModules.colord

    inputs.nix-index-database.hmModules.nix-index
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      # outputs.overlays.unstable-small-packages

      inputs.nur.overlay
      # inputs.chaotic.homeManagerModules.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "${vars.users.users.username}";
    homeDirectory = "/home/${vars.users.users.username}";
    language.base = "zh_CN.UTF-8";
    pointerCursor = {
      name = vars.home.pointerCursor.name;
      package = vars.home.pointerCursor.package pkgs;
      size = vars.home.pointerCursor.size;
      gtk.enable = true;
      x11 = {
        enable = true;
        defaultCursor = vars.home.pointerCursor.name;
      };
    };
    sessionVariables._JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
    file.".cargo/config.toml".text = ''
      [source.crates-io]
      replace-with = 'ustc'
      [source.ustc]
      registry = "sparse+https://mirrors.ustc.edu.cn/crates.io-index/"
    '';
  };

  gtk.cursorTheme = {
    name = vars.home.pointerCursor.name;
    size = vars.home.pointerCursor.size;
  };

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      templates = null;
      publicShare = null;
      desktop = null;
    };
    configFile."pip/pip.conf".text = ''
      [global]
      index-url = https://mirrors.ustc.edu.cn/pypi/web/simple
    '';
    configFile."electron-flags.conf".text = ''
      --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer
      --ozone-platform-hint=auto
      --force-device-scale-factor=1.25
      --ozone-platform=wayland
      --enable-wayland-ime
    '';
  };

  programs = {
    dircolors.enable = true;
    tealdeer = {
      enable = true;
      settings = {
        display.compact = true;
        updates.auto_update = true;
      };
    };
    fish = {
      enable = true;
      interactiveShellInit = ''
        # set -x GOPATH $HOME/go
        # set -x PATH $PATH $GOPATH/bin /usr/local/go/bin
        set -x BUN_INSTALL $HOME/.bun
        set -x PATH $PATH $BUN_INSTALL/bin
        set_proxy
      '';
    };
    home-manager.enable = true;
    atuin = {
      enable = true;
      flags = [
        "--disable-up-arrow"
      ];
      settings = {
        auto_sync = false;
        update_check = false;
        show_help = false;
        enter_accept = true;
      };
    };
    bun = {
      enable = true;
      settings = {
        smol = true;
        telemetry = false;
        install = {
          lockfile.save = false;
          registry = "https://npmreg.proxy.ustclug.org/";
        };
      };
    };
    alacritty = {
      enable = true;
      settings = {
        live_config_reload = false;
        shell.program = "fish";
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
          decorations_theme_variant = "dark";
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
        selection.semantic_escape_chars = ",│`|:\"' ()[]{}<>\t@=";
        debug.log_level = "Off";
        keyboard.bindings = [
          {
            key = "Return";
            mods = "Control|Shift";
            action = "SpawnNewInstance";
          }
        ];
        colors = {
          primary = {
            background = "0x212121";
            foreground = "0xF8F8F2";
          };
          cursor = {
            text = "0x0E1415";
            cursor = "0xECEFF4";
          };
          normal = {
            black = "0x21222C";
            red = "0xFF5555";
            green = "0x50FA7B";
            yellow = "0xFFCB6B";
            blue = "0x82AAFF";
            magenta = "0xC792EA";
            cyan = "0x8BE9FD";
            white = "0xF8F9F2";
          };
          bright = {
            black = "0x545454";
            red = "0xFF6E6E";
            green = "0x69FF94";
            yellow = "0xFFCB6B";
            blue = "0xD6ACFF";
            magenta = "0xFF92DF";
            cyan = "0xA4FFFF";
            white = "0xF8F8F2";
          };
        };
      };
    };
    eza = {
      enable = true;
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
      ignores = [
        # Compiled binary, object files, and libraries
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
        # Dependency directories
        "node_modules/"
        "bower_components/"
        "jspm_packages/"
        # Virtual Environments
        ".env"
        ".env.local"
        ".env.*.local"
        ".Python"
        "[Ii]nclude"
        "[Ll]ib"
        "[Ll]ib64"
        "[Ll]ocal"
        "pyvenv.cfg"
        ".venv"
        "pip-selfcheck.json"
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
        # Python caches and bytecode
        "*.py[cod]"
        "__pycache__/"
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
      difftastic = {
        enable = true;
        background = "dark";
      };
    };
    yazi = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      settings = {
        manager = {
          show_hidden = true;
          sort_dir_first = true;
        };
      };
    };
    # obs-studio = {
    #   enable = true;
    #   plugins = with pkgs.obs-studio-plugins; [
    #     obs-pipewire-audio-capture
    #     obs-scale-to-sound
    #     obs-vaapi
    #   ];
    # };
  };

  services.udiskie.enable = true;

  news.display = "silent";

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.11";
}
