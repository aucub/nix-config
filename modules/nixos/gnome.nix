{ lib, pkgs, ... }:
{
  environment = {
    systemPackages =
      # gnomeExtensions
      (with pkgs.gnomeExtensions; [
        appindicator
        keep-awake
        kimpanel
        battery-health-charging
      ])
      # gnome
      ++ (with pkgs; [
        dconf-editor
        gtop
        gnome-tweaks
      ]);
    gnome.excludePackages = with pkgs; [
      evince
      orca
      gnome-tour
      gnome-menus
      baobab
      epiphany
      gnome-connections
      gnome-console
      yelp
      gnome-terminal
      geary
      gnome-calendar
      simple-scan
      totem
      file-roller
      seahorse
      gnome-contacts
      gnome-initial-setup
      gnome-music
      gnome-clocks
      gnome-characters
      gnome-maps
      gnome-weather
      gnome-software
      tali
      iagno
      hitori
      atomix
      gnome-text-editor
    ];
  };
  services = {
    hardware.bolt.enable = false;
    gnome = {
      at-spi2-core.enable = lib.mkForce false;
      gnome-user-share.enable = false;
      gnome-online-accounts.enable = false;
      gnome-browser-connector.enable = false;
      gnome-initial-setup.enable = false;
      games.enable = false;
      tinysparql.enable = false;
      localsearch.enable = false;
      rygel.enable = false;
      gnome-remote-desktop.enable = false;
      evolution-data-server.enable = lib.mkForce false;
    };
    xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
  qt = {
    enable = true;
    style = "adwaita";
    platformTheme = "gnome";
  };
  systemd.user.services = {
    "org.gnome.SettingsDaemon.Sharing".enable = false;
    "org.gnome.SettingsDaemon.Smartcard".enable = false;
    "org.gnome.SettingsDaemon.Wacom".enable = false;
  };
}
