{pkgs, ...}: {
  xdg.configFile."electron-flags.conf".source = ".config/electron-flags.conf";

  xdg.configFile."tlrc".source = ".config/tlrc";
}
