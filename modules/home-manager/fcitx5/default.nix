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
    '';

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-configtool
      fcitx5-gtk
      libsForQt5.fcitx5-qt
      fcitx5-chinese-addons
      fcitx5-table-extra
    ];
  };

  systemd.user.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "fcitx";
    INPUT_METHOD = "fcitx";
    IMSETTINGS_MODULE = "fcitx";
  };
}
