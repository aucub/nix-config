{ config, lib, pkgs, ... }:
{
  home.file.".config/mako" = {
    source = ./mako;
    recursive = true;
  };
  home.file.".config/waybar".source = ./waybar;
  home.file.".config/wlogout".source = ./wlogout;
  home.file.".config/wofi".source = ./wofi;
}
