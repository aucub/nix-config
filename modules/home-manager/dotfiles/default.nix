{...}: {
  xdg.configFile."electron-flags.conf".source = .config/electron-flags.conf;

  xdg.configFile."fish/functions/set_proxy.fish".source = .config/fish/functions/set_proxy.fish;
}
