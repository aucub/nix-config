{ config, lib, pkgs, ... }:
{
  imports = [
    (import ../environment/variables.nix)
  ];
  home.file.".config/hypr" = {
    source = ./hypr-conf;
    recursive = true;
  };

  programs = {
    light.enable = true;
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
        hidpi = true;
      };
      nvidiaPatches = true;
    };
    bash = {
      initExtra = ''
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
            exec  Hyprland
        fi
      '';
    };
    fish = {
      loginShellInit = ''
        set TTY1 (tty)
        [ "$TTY1" = "/dev/tty1" ] && exec Hyprland
      '';
    };
  };

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
    };
    displayManager = {
      defaultSession = "hyprland";
      lightdm.enable = false;
      gdm = {
        enable = false;
        wayland = true;
      };
    };
  };


  environment.systemPackages = with pkgs; [
    waybar # the status bar
    swaybg # the wallpaper
    swayidle # the idle timeout
    swaylock # locking the screen
    wlogout # logout menu
    wl-clipboard # copying and   pasting
    wlr-randr
    wf-recorder # creen recording
    grim # taking screenshots
    slurp # selecting a region   to screenshot
    wofi 
    mako # the notification   daemon, the same as dunst
    yad # a fork of zenity, for   creating dialogs
    hyprpicker
    swaylock-effects
    pamixer
  ];

  systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  
  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    nvidiaPatches = true;
  };
}