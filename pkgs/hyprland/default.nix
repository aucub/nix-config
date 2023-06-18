{ config, lib, pkgs, ... }:
{
  programs = {
    dconf.enable = true;
    light.enable = true;
  };

  environment.systemPackages = with pkgs; [
    hyprpicker
    swaylock-effects
    pamixer
  ];

  security.pam.services.swaylock = { };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  home-manager.users.nix = {
    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "graphical-session.target";
      };
    }

}