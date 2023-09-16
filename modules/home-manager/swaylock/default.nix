{ pkgs, config, lib, ... }: {

  home.file.".swaylock/config".source = ./config;

}
