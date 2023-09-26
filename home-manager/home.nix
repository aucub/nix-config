# home-manager配置文件
# 使用此文件来配置您的主目录环境(~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # 在此处导入其他 home-manager 模块
  imports = [
    # 如果您想使用您自己的 flakes 导出的模块(来自modules/home-manager)
    # outputs.homeManagerModules.example
    # outputs.homeManagerModules.fcitx5
    # outputs.homeManagerModules.fastfetch

    # 或者从其他 flakes 导出的模块(例如 nix-colors)
    # inputs.nix-colors.homeManagerModules.default

    # 在此处拆分配置并导入其中的各个部分
    # ./nvim.nix
  ];

  nixpkgs = {
    # 可以在这里添加overlays
    overlays = [
      # 添加您自己的flake导出的overlays(来自overlays和 pkgs 目录)
      # outputs.overlays.additions
      # outputs.overlays.modifications
      # outputs.overlays.unstable-packages

      # 添加从其他flake导出的overlays
      # neovim-nightly-overlay.overlays.default

      # 或者内联定义它,例如
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # 配置 nixpkgs 实例
    config = {
      # 如果您不需要 Unfree 的软件包,请禁用
      allowUnfree = true;
      # 解决方法 https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  # 设置用户名
  home = {
    username = "yrumily";
    homeDirectory = "/home/yrumily";
    language.base = "zh_CN.UTF-8";
  };

  # 根据您的需要为您的用户添加内容
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # 启用 home-manager 和 git
  # programs.home-manager.enable = true;
  # programs.git.enable = true;

  programs = {
    vscode = {
      enable = true;
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        # ms-vscode.cpptools
        ms-ceintl.vscode-language-pack-zh-hans
        # formulahendry.code-runner
        mhutchie.git-graph
        # github.github-vscode-theme
        oderwat.indent-rainbow
        # rust-lang.rust-analyzer
        redhat.vscode-yaml
        redhat.vscode-xml
        # vscode-icons-team.vscode-icons
        yzhang.markdown-all-in-one
      ];
      userSettings = {
        "extensions.ignoreRecommendations" = true;
        "window.dialogStyle" = "custom";
        "window.titleBarStyle" = "custom";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.fontFamily" = ''"Sarasa Mono SC",monospace'';
        "editor.codeLensFontFamily" = ''"Sarasa Mono SC",monospace'';
        "editor.fontLigatures" = true;
        "editor.fontSize" = 18;
        "editor.suggestSelection" = "first";
        "files.exclude" = {
          "**/.classpath" = true;
          "**/.factorypath" = true;
          "**/.project" = true;
          "**/.settings" = true;
          "**/.vscode" = true;
        };
        "workbench.startupEditor" = "none";
        "security.workspace.trust.untrustedFiles" = "open";
        "editor.inlineSuggest.enabled" = true;
        "editor.acceptSuggestionOnCommitCharacter" = false;
        "telemetry.telemetryLevel" = "off";
        "update.showReleaseNotes" = false;
        "editor.wordWrap" = "on";
        "code-runner.runInTerminal" = true;
        "terminal.integrated.defaultProfile.linux" = "fish";
        "vsicons.dontShowNewVersionMessage" = true;
        "workbench.colorTheme" = "Quiet Light";
        "github.gitProtocol" = "ssh";
        "explorer.confirmDelete" = false;
      };
    };
    # 启用 home-manager and git
    home-manager.enable = true;
    # git 相关配置
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
        "out"
        "!**/src/main/**/out"
        "!**/src/test/**/out"
      ];
      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "nvim";
      };
    };
    mcfly = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
    tealdeer = {
      enable = true;
      settings = {
        display = {
          compact = true;
          use_pager = true;
        };
        updates = { auto_update = false; };
      };
    };
    lazygit = {
      enable = true;
      settings = {
        os.disableStartupPopups = true;
        os.edit = "nvim";
      };
    };
    htop = {
      enable = true;
      settings = {
        hide_kernel_threads = 1;
        hide_userland_threads = 1;
        color_scheme = 6;
      };
    };
    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "github_dark_colorblind";
        editor = { file-picker.hidden = false; };
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
    alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
        font = {
          normal = {
            family = "Sarasa Mono SC";
            style = "Regular";
          };
          bold = {
            family = "Sarasa Mono SC";
            style = "Bold";
          };
          italic = {
            family = "Sarasa Mono SC";
            style = "Italic";
          };
          bold_italic = {
            family = "Sarasa Mono SC";
            style = "Bold Italic";
          };
          offset = {
            x = 1;
            y = 0;
          };
          size = 14;
        };
        colors = {
          primary = {
            background = "0x191622";
            foreground = "0xe1e1e6";
          };
          cursor = {
            text = "0x191622";
            cursor = "0xf8f8f2";
          };
          normal = {
            black = "0x000000";
            red = "0xff5555";
            green = "0x50fa7b";
            yellow = "0xeffa78";
            blue = "0xbd93f9";
            magenta = "0xff79c6";
            cyan = "0x8d79ba";
            white = "0xbfbfbf";
          };
          bright = {
            black = "0x4d4d4d";
            red = "0xff6e67";
            green = "0x5af78e";
            yellow = "0xeaf08d";
            blue = "0xcaa9fa";
            magenta = "0xff92d0";
            cyan = "0xaa91e3";
            white = "0xe6e6e6";
          };
          dim = {
            black = "0x000000";
            red = "0xa90000";
            green = "0x049f2b";
            yellow = "0xa3b106";
            blue = "0x530aba";
            magenta = "0xbb006b";
            cyan = "0x433364";
            white = "0x5f5f5f";
          };
        };
        scrolling.multiplier = 3;
        selection.save_to_clipboard = false;
        window.opacity = 1;
        window.dynamic_title = true;
      };
    };
  };

  # 更改配置时很好地重新加载系统单元
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
