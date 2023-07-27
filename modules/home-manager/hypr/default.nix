{ config, lib, pkgs, ... }: {
  home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
  home.file.".config/hypr/hyprland.conf-bak".source = ./hyprland.conf;
  home.activation.removeExistingHyprlandProfile =
    lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      rm -f "${config.xdg.configHome}/hypr/hyprland.conf"
    '';
  home.file.".config/gtk-3.0".source = ./gtk-3.0;
  home.file.".config/hypr/mako" = {
    source = ./mako;
    recursive = true;
  };
  home.file.".config/hypr/scripts" = {
    source = ./scripts;
    recursive = true;
  };
  home.file.".config/hypr/waybar".source = ./waybar;
  # home.file.".config/hypr/wlogout".source = ./wlogout;
  home.file.".config/hypr/wofi".source = ./wofi;
  home.file.".config/hypr/wallpapers/wallpaper.jpg".source = ./wallpaper.jpg;
}
