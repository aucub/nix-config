{
  pkgs,
  config,
  lib,
  ...
}: {
  xdg.configFile."fastfetch/config.conf".source = ./config.conf;
}
