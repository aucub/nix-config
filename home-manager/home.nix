{
  inputs,
  outputs,
  lib,
  config,
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

    inputs.nix-index-database.hmModules.nix-index
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      inputs.nur.overlay
    ];
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "${vars.users.users.username}";
    homeDirectory = "/home/${vars.users.users.username}";
    language.base = "zh_CN.UTF-8";
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      bashrcExtra = ''
        PS1='[\u@\h \W]\$ '
      '';
      shellAliases = {
        ls = "ls --color=auto";
        grep = "grep --color=auto";
      };
    };
    fish = {
      enable = true;
      interactiveShellInit = ''
        # set -x GOPATH $HOME/go
        # set -x PATH $PATH $GOPATH/bin /usr/local/go/bin
        # set -x PNPM_HOME $HOME/.local/share/pnpm
        # set -x PATH $PATH $PNPM_HOME
        set -x BUN_INSTALL $HOME/.bun
        set -x PATH $PATH $BUN_INSTALL/bin
        set_proxy
      '';
    };
    home-manager.enable = true;
    gh.gitCredentialHelper.enable = true;
    atuin = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
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
        install.lockfile = {
          save = false;
        };
      };
    };
    alacritty = {
      enable = true;
      settings = {
        live_config_reload = false;

        shell = {
          program = "fish";
        };

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

        selection = {
          semantic_escape_chars = ",│`|:\"' ()[]{}<>\t@=";
        };

        debug = {
          log_level = "Off";
        };

        keyboard = {
          bindings = [
            {
              key = "Return";
              mods = "Control|Shift";
              action = "SpawnNewInstance";
            }
          ];
        };
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
      enableFishIntegration = true;
      enableBashIntegration = true;
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
    yazi = {
      enableBashIntegration = true;
      enableFishIntegration = true;
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

  services = {
    udiskie = {
      enable = true;
      automount = true;
      tray = "auto";
    };
  };

  news.display = "silent";

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.05";
}
