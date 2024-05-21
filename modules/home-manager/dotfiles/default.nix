{pkgs, ...}: {
  xdg.configFile."electron-flags.conf".source = .config/electron-flags.conf;

  xdg.configFile."tlrc".source = .config/tlrc;

  xdg.configFile."fish/functions/set_proxy.fish".source = .config/fish/functions/set_proxy.fish;
}
