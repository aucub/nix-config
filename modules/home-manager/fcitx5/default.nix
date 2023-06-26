{ pkgs, config, lib, ... }: {

  home.file.".config/fcitx5/profile".source = ./profile;
  home.file.".config/fcitx5/profile-bak".source = ./profile;

  home.activation.removeExistingFcitx5Profile = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f "${config.xdg.configHome}/fcitx5/profile"
  '';

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-chinese-addons fcitx5-table-extra
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