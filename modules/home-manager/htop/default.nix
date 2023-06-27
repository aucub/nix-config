{ pkgs, config, lib, ... }: {

  home.file.".config/htop/htoprc".source = ./htoprc;

}