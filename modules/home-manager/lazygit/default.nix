{ config, lib, pkgs, ... }: {
  home.file.".config/lazygit/config.yml" = {
    source = ./config.yml;
    recursive = true;
  };
}
