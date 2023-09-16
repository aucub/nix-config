{ pkgs, config, lib, ... }: {

  home.file.".config/tealdeer/config.toml".source = ./config.toml;

}
