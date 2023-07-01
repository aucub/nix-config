{ config, lib, pkgs, ... }:
{
  home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
  home.file.".config/gtk-3.0".source = ./gtk-3.0;
  home.file.".config/mako" = {
    source = ./mako;
    recursive = true;
  };
  home.file.".config/waybar".source = ./waybar;
  home.file.".config/wlogout".source = ./wlogout;
  home.file.".config/wofi".source = ./wofi;
  home.file.".config/hypr/wallpapers/wallpaper.jpg".source = ./wallpaper.jpg;
}
