{ config, lib, pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      noto-fonts 
      noto-fonts-cjk-sans
      noto-fonts-emoji
      sarasa-gothic
      source-sans
      source-serif 
      source-han-sans 
      source-han-serif 
      FiraCode
      Iosevka
    ];

    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Noto Color Emoji" ];
      sansSerif = [ "Sarasa UI SC" "Noto Color Emoji" ];
      monospace = [ "Sarasa Mono SC" "Noto Color Emoji" ];
      emoji = [ "Noto Color Emoji" ];
    };

}