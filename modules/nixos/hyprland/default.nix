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
        command = "Hyprland"; # ${pkgs.greetd.gtkgreet}/bin/gtkgreet --command
        user = "nix";
      };
      default_session = initial_session;
    };
  };

  environment.systemPackages = with pkgs; [
    waybar # the status bar
    swaybg # the wallpaper
    hyprpaper
    hyprland-protocols
    swayidle # the idle timeout
    swaylock # locking the screen
    wlogout # logout menu
    nwg-bar
    wl-clipboard
    wl-clipboard-x11
    wlr-randr
    wf-recorder # creen recording
    grim # taking screenshots
    slurp # selecting a region   to screenshot
    wofi
    mako # the notification   daemon, the same as dunst
    swayosd
    yad # a fork of zenity, for   creating dialogs
    hyprpicker
    swaylock-effects
    pamixer
    obs-studio-plugins.wlrobs
    udiskie
  ];

  environment.systemPackages = [ nixpkgs-unstable.wl-clip-persist ];

  systemd.user.targets.hyprland-session.wants =
    [ "xdg-desktop-autostart.target" ];
}
