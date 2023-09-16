{ pkgs, config, lib, ... }: {

  programs.btop = { enable = true; };
  home.file.".config/btop/btop.conf" = {
    source = ./btop.conf;
    recursive = true;
  };

  home.file.".config/btop/themes/monokai.theme" = {
    source = ./themes/monokai.theme;
    recursive = true;
  };

}