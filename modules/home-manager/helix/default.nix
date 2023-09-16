{ pkgs, config, lib, ... }: {

  home.file.".config/helix/config.toml".source = ./config.toml;

}