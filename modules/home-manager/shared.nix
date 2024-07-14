{ vars, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  home = {
    username = "${vars.users.users.user.username}";
    homeDirectory = "/home/${vars.users.users.user.username}";
    language.base = "zh_CN.UTF-8";
    # file.".cargo/config.toml".text = ''
    #   [source.crates-io]
    #   replace-with = 'ustc'
    #   [source.ustc]
    #   registry = "sparse+https://mirrors.ustc.edu.cn/crates.io-index/"
    # '';
  };

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      templates = null;
      publicShare = null;
      desktop = null;
    };
    configFile."nixpkgs/config.nix".text = ''
      {
        allowUnfree = true;
      }
    '';
    configFile."uv/uv.toml".text = ''
      [pip]
      index-url = "https://mirrors.ustc.edu.cn/pypi/web/simple"
    '';
    configFile."pip/pip.conf".text = ''
      [global]
      index-url = https://mirrors.ustc.edu.cn/pypi/web/simple
    '';
  };

  programs = {
    tealdeer = {
      enable = true;
      settings = {
        display.compact = true;
        updates.auto_update = false;
      };
    };
    home-manager.enable = true;
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
    bun = {
      enable = false;
      settings = {
        smol = true;
        telemetry = false;
        install = {
          # lockfile.save = false;
          registry = "https://npmreg.proxy.ustclug.org/";
        };
        run.bun = true;
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
      hooks = {
        pre-commit = pkgs.writeScript "pre-commit-script" ''
          #!/bin/sh
          gitleaks protect --staged --no-banner --max-target-megabytes 1
        '';
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
  };

  manual.manpages.enable = false;

  news.display = "silent";

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.11";
}
