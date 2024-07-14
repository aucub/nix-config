{
  inputs,
  outputs,
  vars,
  pkgs,
  ...
}:
{
  imports = [
    outputs.homeManagerModules.shared
    outputs.homeManagerModules.dotfiles
    outputs.homeManagerModules.firefox
    outputs.homeManagerModules.vscode
    outputs.homeManagerModules.dconf
    outputs.homeManagerModules.chromium
    outputs.homeManagerModules.wofi
    outputs.homeManagerModules.colord

    inputs.nix-index-database.hmModules.nix-index
  ];

  nixpkgs.overlays = [
    outputs.overlays.additions
    outputs.overlays.modifications
    # outputs.overlays.unstable-small-packages

    inputs.nur.overlay
    # inputs.chaotic.homeManagerModules.default
  ];

  home = {
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
    # sessionVariables._JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
  };

  gtk.cursorTheme = {
    name = vars.home.pointerCursor.name;
    size = vars.home.pointerCursor.size;
  };

  xdg = {
    configFile."electron-flags.conf".text = ''
      --log-level=0
      --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer
      --ozone-platform-hint=auto
    '';
  };

  programs = {
    nix-index = {
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
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
      shellAbbrs = {
        navicat-reset = "${pkgs.dconf}/bin/dconf reset -f /com/premiumsoft/ && cd ~/.config/navicat/Premium/ && ${pkgs.jq}/bin/jq 'del(.[\"014BF4EC24C114BEF46E1587042B3619\"])' preferences.json > tmp.json && mv tmp.json preferences.json";
      };
    };
    alacritty = {
      enable = true;
      settings = {
        import = [ "${pkgs.alacritty-theme}/dracula_plus.toml" ];
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
        selection.semantic_escape_chars = ",│`|:\"' ()[]{}<>\t@=";
        debug.log_level = "Off";
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

  services.udiskie.enable = true;
}
