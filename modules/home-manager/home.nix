{ config, pkgs, ... }:

{

  # git 相关配置
  programs.git = {
    enable = true;
    userName = "aucub";
    userEmail = "78630225+aucub@users.noreply.github.com";
  };

  # 通过 home.packages 安装一些常用的软件
  # 这些软件将仅在当前用户下可用，不会影响系统级别的配置
  # 建议将所有 GUI 软件，以及与 OS 关系不大的 CLI 软件，都通过 home.packages 安装
  home.packages = with pkgs;[
    nix-software-center
    firefox
    flameshot
    cargo
    celluloid
    clash-meta
    clash-geoip
    clash-verge
  ];

}