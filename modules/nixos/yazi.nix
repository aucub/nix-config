{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.yazi = {
    enable = true;
    settings.yazi = {
      manager = {
        sort_dir_first = true;
        show_hidden = true;
      };
    };
  };
}
