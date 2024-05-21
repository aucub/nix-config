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
    outputs.homeManagerModules.firefox
    outputs.homeManagerModules.vscode
    outputs.homeManagerModules.dconf

    inputs.nix-index-database.hmModules.nix-index
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
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
    home-manager.enable = true;
    gh.gitCredentialHelper.enable = true;
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
