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

  services.swayosd-libinput-backend = { enable = true; };

  environment.systemPackages = with pkgs; [
    waybar # the status bar
    swaybg # the wallpaper
    hyprpaper
    hyprland-protocols
    swayidle # the idle timeout
    swaylock # locking the screen
    wlogout # logout menu
    wl-clipboard # copying and   pasting
    wl-clip-persist
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

  systemd.user.targets.hyprland-session.wants =
    [ "xdg-desktop-autostart.target" ];
}
