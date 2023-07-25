{ pkgs, config, lib, ... }: {

  programs.fish = { enable = true; };
  home.file.".config/fish/config.fish".source = ./config.fish;
  home.file.".config/fish/fish_variables".source = ./fish_variables;
  home.file.".config/fish/functions".source = ./functions;
}