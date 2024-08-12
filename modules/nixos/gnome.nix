{ lib, pkgs, ... }:
{
  environment = {
    systemPackages =
      # gnomeExtensions
      (with pkgs.gnomeExtensions; [
        appindicator
        caffeine
        kimpanel
      ])
      # gnome
      ++ (with pkgs; [
        dconf-editor
        gnome-tweaks
        gtop
      ]);
    gnome.excludePackages =
      (with pkgs; [
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
      ])
      ++ (with pkgs.gnome; [
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
      ]);
  };
  services = {
    hardware.bolt.enable = false; # Thunderbolt
    gnome = {
      at-spi2-core.enable = lib.mkForce false;
      gnome-user-share.enable = false;
      gnome-online-accounts.enable = false;
      gnome-browser-connector.enable = false;
      gnome-initial-setup.enable = false;
      gnome-online-miners.enable = lib.mkForce false;
      games.enable = false;
      tracker.enable = false;
      tracker-miners.enable = false;
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
    style = "adwaita";
    platformTheme = "gnome";
  };
  systemd.user.services = {
    "org.gnome.SettingsDaemon.Sharing".enable = false;
    "org.gnome.SettingsDaemon.Smartcard".enable = false;
    "org.gnome.SettingsDaemon.Wacom".enable = false;
  };
}
