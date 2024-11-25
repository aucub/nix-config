{
  flake,
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (flake) inputs;
  inherit (inputs) self;
  username = "uymi";
  user = flake.config.users."${config.home.username}";
  cursorName = user.cursorName;
  cursorPackage = user.cursorPackage pkgs;
  cursorSize = user.cursorSize;
in
{
  imports =
    [ flake.inputs.nix-index-database.hmModules.nix-index ]
    ++ [
      self.homeModules.chromium
      self.homeModules.firefox
      self.homeModules.vscode
      # self.homeModules.zed-editor
    ]
    ++ [
      self.homeModules.colord
      self.homeModules.dotfiles
      self.homeModules.dconf
      # self.homeModules.wofi
    ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = lib.trivial.release;
    pointerCursor = {
      name = cursorName;
      package = cursorPackage;
      size = cursorSize;
      gtk.enable = true;
      x11 = {
        enable = true;
        defaultCursor = cursorName;
      };
    };
    language.base = "zh_CN.UTF-8";
  };

  gtk.cursorTheme = {
    name = cursorName;
    size = cursorSize;
  };

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      templates = null;
      publicShare = null;
      desktop = null;
    };
    mimeApps = {
      enable = true;
      defaultApplications =
        let
          browser = [ "firefox.desktop" ];
          image = [ "org.gnome.Loupe.desktop" ];
        in
        {
          "text/html" = browser;
          "application/pdf" = browser;
          "x-scheme-handler/http" = browser;
          "x-scheme-handler/https" = browser;
          "image/jpeg" = image;
          "image/png" = image;
          "image/gif" = image;
          "image/webp" = image;
          "image/tiff" = image;
          "image/bmp" = image;
          "image/vnd-ms.dds" = image;
          "image/vnd.microsoft.icon" = image;
          "image/vnd.radiance" = image;
          "image/x-exr" = image;
          "image/x-dds" = image;
          "image/x-tga" = image;
          "image/x-portable-bitmap" = image;
          "image/x-portable-graymap" = image;
          "image/x-portable-pixmap" = image;
          "image/x-portable-anymap" = image;
          "image/x-qoi" = image;
          "image/svg+xml" = image;
          "image/svg+xml-compressed" = image;
          "image/avif" = image;
          "image/heic" = image;
          "image/jxl" = image;
        };
      associations.removed = {
        "application/x-zerosize" = "org.gnome.TextEditor.desktop";
        "x-content/unix-software" = "nautilus-autorun-software.desktop";
        "x-scheme-handler/unknown" = "chromium-browser.desktop";
        "x-scheme-handler/mailto" = "chromium-browser.desktop";
        "x-scheme-handler/webcal" = "chromium-browser.desktop";
        "x-scheme-handler/about" = "chromium-browser.desktop";
        "x-scheme-handler/rlogin" = "ktelnetservice6.desktop";
        "x-scheme-handler/ssh" = "ktelnetservice6.desktop";
        "x-scheme-handler/telnet" = "ktelnetservice6.desktop";
        "audio/x-mod" = "io.github.celluloid_player.Celluloid.desktop";
      };
    };
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
        + (lib.optionalString config.programs.bun.enable ''
          set -x BUN_INSTALL $HOME/.bun
          set -x PATH $PATH $BUN_INSTALL/bin
        '');
      shellAbbrs.navicat-reset = "${pkgs.dconf}/bin/dconf reset -f /com/premiumsoft/ && ${pkgs.jq}/bin/jq 'with_entries(select(.key | length != 32))' ~/.config/navicat/Premium/preferences.json > ~/.config/navicat/Premium/tmp.json && mv ~/.config/navicat/Premium/tmp.json ~/.config/navicat/Premium/preferences.json";
      functions = {
        nix-loc = "nix-locate $argv | rga -v '\\('";
        nvdd = ''
          set old_version $argv[1]
          set new_version $argv[2]
          ${pkgs.nvd}/bin/nvd diff /nix/var/nix/profiles/system-$old_version-link /nix/var/nix/profiles/system-$new_version-link
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
        ca = "commit --amend --no-edit --reset-author";
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

  systemd.user = {
    sessionVariables = {
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      QT_ENABLE_HIGHDPI_SCALING = 1;
    };
    startServices = "sd-switch";
  };
}
