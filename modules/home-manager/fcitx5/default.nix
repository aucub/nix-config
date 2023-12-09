{
  config,
  lib,
  ...
}: {
  xdg.configFile.".config/fcitx5/profile".source = ./profile;
  xdg.configFile.".config/fcitx5/config".source = ./config;
  xdg.configFile.".config/fcitx5/conf".source = ./conf;
  xdg.configFile.".config/fcitx5/profile-bak".source = ./profile;

  home.activation.removeExistingFcitx5Profile = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    rm -f "${config.xdg.configHome}/fcitx5/profile"
  '';
}
