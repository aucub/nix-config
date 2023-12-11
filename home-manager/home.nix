# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  vars,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    # outputs.homeManagerModules.fcitx5
    outputs.homeManagerModules.firefox
    # outputs.homeManagerModules.chromium
    outputs.homeManagerModules.dconf
    outputs.homeManagerModules.vscode

    # Or modules exported from other flakes:
    # inputs.stylix.homeManagerModules.stylix
    inputs.nix-index-database.hmModules.nix-index

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
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

  # TODO: Set your username
  home = {
    username = "${vars.username}";
    homeDirectory = "/home/${vars.username}";
    language.base = "zh_CN.UTF-8";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [steam];

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # Enable home-manager and git
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
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "aucub";
      userEmail = "78630225+aucub@users.noreply.github.com";
      ignores = [
        ".cache"
        ".DS_Store"
        ".idea"
        ".fastRequest"
        "node_modules"
        ".vscode"
        ".gradle"
        "build"
        "!**/src/main/**/build"
        "!**/src/test/**/build"
        "*.iws"
        "*.iml"
        "*.ipr"
        "*.log"
        "out"
        "!**/src/main/**/out"
        "!**/src/test/**/out"
        ".venv"
      ];
      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "helix";
        core.autocrlf = "input";
        push.autoSetupRemote = true;
        core.pager = "bat";
        diff.tool = "difftastic";
        difftool.prompt = false;
        difftool.difftastic.cmd = ''difft "$LOCAL" "$REMOTE"'';
        pager.difftool = true;
      };
    };
    eza = {
      enable = true;
      git = true;
      extraOptions = ["--group-directories-first" "--all"];
    };
    mcfly = {
      enable = true;
      enableFishIntegration = true;
    };
    fish.functions = {
      rga-fzf = ''
            set RG_PREFIX 'rga --files-with-matches'
            if test (count $argv) -gt 1
                set RG_PREFIX "$RG_PREFIX $argv[1..-2]"
            end
            set -l file $file
            set file (
            FZF_DEFAULT_COMMAND="$RG_PREFIX '$argv[-1]'" \
            fzf --sort \
                --preview='test ! -z {} && \
                    rga --pretty --context 5 {q} {}' \
                --phony -q "$argv[-1]" \
                --bind "change:reload:$RG_PREFIX {q}" \
                --preview-window='50%:wrap'
        ) && echo "opening $file" && open "$file"
        end
      '';
    };
    htop = {
      enable = true;
      settings = {
        hide_kernel_threads = 1;
        hide_userland_threads = 1;
        show_program_path = 0;
        highlight_base_name = 1;
        show_cpu_frequency = 1;
        show_cpu_temperature = 1;
        color_scheme = 6;
      };
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
    fzf = {
      enable = true;
      defaultCommand = "rga --files || fd || find .";
      defaultOptions = [
        "--preview='bat {} -n --color=always'"
        "--preview-window='right,50%,wrap,border-none'"
        "--border=none"
        "--layout=reverse"
        "--bind 'enter:become(helix {})'"
      ];
      colors = {
        "bg+" = "#313244";
        "bg" = "#1e1e2e";
        "spinner" = "#f5e0dc";
        "hl" = "#f38ba8";
        "fg" = "#cdd6f4";
        "header" = "#f38ba8";
        "info" = "#cba6f7";
        "pointer" = "#f5e0dc";
        "marker" = "#f5e0dc";
        "fg+" = "#cdd6f4";
        "prompt" = "#cba6f7";
        "hl+" = "#f38ba8";
      };
    };
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
        obs-scale-to-sound
        obs-vaapi
      ];
    };
  };

  services = {
    udiskie = {
      enable = true;
      automount = true;
      tray = "auto";
    };
  };

  # notifications about home-manager news
  news.display = "silent";

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
