{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages =
    # gnomeExtensions
    (with pkgs.gnomeExtensions; [
      appindicator
      caffeine
      kimpanel
    ])
    # gnome
    ++ (with pkgs.gnome; [
      dconf-editor
      gnome-tweaks
    ]);
  environment.gnome.excludePackages =
    (with pkgs; [
      orca
      tecla
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
      cheese # webcam tool
      gnome-music
      gnome-terminal
      epiphany # web browser
      geary # email reader
      gnome-calendar
      gnome-clocks
      gnome-characters
      gnome-maps
      gnome-weather
      gnome-software
      simple-scan
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      file-roller
      seahorse
    ]);
  programs.seahorse.enable = false;
  programs.gnome-terminal.enable = false;
  programs.file-roller.enable = false;
  services.gnome = {
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
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
}
