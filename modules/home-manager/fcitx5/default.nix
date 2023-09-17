{ pkgs, config, lib, ... }: {

  home.file.".config/fcitx5/profile".source = ./profile;
  home.file.".config/fcitx5/config".source = ./config;
  home.file.".config/fcitx5/conf".source = ./conf;
  home.file.".config/fcitx5/profile-bak".source = ./profile;
  home.file.".local/share/fcitx5/themes/fcitx5-skin-material".source =
    ./fcitx5-skin-material;

  home.activation.removeExistingFcitx5Profile =
    lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      rm -f "${config.xdg.configHome}/fcitx5/profile"
      rm -rf "${config.xdg.dataHome}/fcitx5/themes/fcitx5-skin-material"
    '';
}
