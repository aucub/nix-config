{ pkgs, ... }:

{
  programs.bat = { enable = true; };

  home.file.".config/bat/config" = {
    source = ./config;
    recursive = true;
  };
}
