{ config, lib, pkgs, ... }: {
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
  };

  services.greetd = {
    enable = true;
    vt = 1;
    restart = false;
    settings = rec {
      initial_session = {
        command = "Hyprland";
        user = "nix";
      };
      default_session = initial_session;
    };
  };

  environment.systemPackages = with pkgs; [
    waybar # the status bar
    swaybg # the wallpaper
    hyprland-protocols
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
    obs-studio-plugins.wlrobs
  ];

  systemd.user.targets.hyprland-session.wants =
    [ "xdg-desktop-autostart.target" ];
}
