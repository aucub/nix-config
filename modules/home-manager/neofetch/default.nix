{ pkgs, config, lib, ... }: {

  home.file.".config/neofetch/config.conf".source = ./config.conf;

}
