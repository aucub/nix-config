# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  outputs,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    # outputs.homeManagerModules.fcitx5
    # outputs.homeManagerModules.fastfetch
    # outputs.homeManagerModules.firefox
    # outputs.homeManagerModules.chromium

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

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
    username = "${username}";
    homeDirectory = "/home/${username}";
    language.base = "zh_CN.UTF-8";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
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
        formulahendry.code-runner
        mhutchie.git-graph
        oderwat.indent-rainbow
        # rust-lang.rust-analyzer
        redhat.vscode-yaml
        redhat.vscode-xml
        yzhang.markdown-all-in-one
        ms-python.python
        ms-python.vscode-pylance
        # ms-python.black-formatter
        charliermarsh.ruff
        foxundermoon.shell-format
        tamasfe.even-better-toml
        bmalehorn.vscode-fish
      ];
      userSettings = {
        "extensions.ignoreRecommendations" = true;
        "window.dialogStyle" = "custom";
        "window.titleBarStyle" = "custom";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.fontFamily" = ''"Sarasa Mono SC",monospace'';
        "editor.fontLigatures" = true;
        "editor.fontSize" = 18;
        "editor.suggestSelection" = "first";
        "files.exclude" = {
          "**/.classpath" = true;
          "**/.factorypath" = true;
          "**/.project" = true;
          "**/.settings" = true;
          "**/.vscode" = true;
          "**/**.exe" = true;
        };
        "workbench.startupEditor" = "none";
        "grunt.autoDetect" = "on";
        "security.workspace.trust.untrustedFiles" = "open";
        "editor.inlineSuggest.enabled" = true;
        "emmet.syntaxProfiles" = {
          "vue-html" = "html";
          "vue" = "html";
        };
        "editor.acceptSuggestionOnCommitCharacter" = false;
        "telemetry.telemetryLevel" = "off";
        "update.showReleaseNotes" = false;
        "editor.wordWrap" = "on";
        "code-runner.runInTerminal" = true;
        "files.autoSave" = "onWindowChange";
        "indentRainbow.colors" = [
          "rgba(255,255,64,0.07)"
          "rgba(127,255,127,0.07)"
          "rgba(255,127,255,0.07)"
          "rgba(79,236,236,0.07)"
        ];
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "explorer.confirmDelete" = false;
        "[json]" = {
          "editor.defaultFormatter" = "vscode.json-language-features";
        };
        "[markdown]" = {
          "editor.defaultFormatter" = "yzhang.markdown-all-in-one";
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "vscode.typescript-language-features";
        };
        "workbench.enableExperiments" = false;
        "window.autoDetectColorScheme" = true;
        "terminal.integrated.defaultProfile.linux" = "fish";
        "update.mode" = "none";
        "editor.codeLensFontFamily" = ''"Sarasa Mono SC",monospace'';
        "github.gitProtocol" = "ssh";
        "[python]" = {"editor.defaultFormatter" = "mikoz.black-py";};
        "editor.accessibilitySupport" = "off";
        "window.commandCenter" = false;
        "code-runner.showExecutionMessage" = false;
        "diffEditor.ignoreTrimWhitespace" = true;
        "redhat.telemetry.enabled" = false;
        "bitoAI.codeCompletion.enableAutoCompletion" = true;
        "bitoAI.codeCompletion.enableCommentToCode" = true;
        "workbench.colorTheme" = "Quiet Light";
        "code-runner.enableAppInsights" = false;
        "editor.inlineSuggest.suppressSuggestions" = true;
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
        theme = "github_dark_colorblind";
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
      fuzzyCompletion = true;
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

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
