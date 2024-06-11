{
  lib,
  pkgs,
  ...
}: {
  qt = {
    style = "adwaita";
    platformTheme = "gnome";
  };
  environment.gnome.excludePackages =
    (with pkgs; [
      orca
      gnome-tecla
      gnome-tour
      gnome-photos
      gnome-menus
      baobab
      epiphany
      gnome-connections
      libsForQt5.qt5ct
      qt6Packages.qt6ct
      gnome-console
    ])
    ++ (with pkgs.gnome; [
      gnome-contacts
      gnome-initial-setup
      yelp
      cheese
      gnome-music
      gnome-terminal
      epiphany
      geary
      gnome-calendar
      gnome-clocks
      gnome-characters
      gnome-maps
      gnome-weather
      gnome-software
      simple-scan
      totem
      tali
      iagno
      hitori
      atomix
      file-roller
      seahorse
    ]);
  programs = {
    seahorse.enable = false;
    gnome-terminal.enable = false;
    file-roller.enable = false;
  };
  services = {
    gnome = {
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
      gnome-keyring.enable = true;
      glib-networking.enable = true;
    };
    xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
}
