{
  flake,
  pkgs,
  lib,
  ...
}:
let
  inherit (flake) inputs;
  inherit (inputs) self;
  username = "uymi";
in
{
  imports = [
    self.homeModules.colord
    self.homeModules.dotfiles
    self.homeModules.chromium
    self.homeModules.dconf
    self.homeModules.firefox
    self.homeModules.gui
    self.homeModules.shell
    self.homeModules.vscode
    self.homeModules.wofi
  ];

  home = {
    username = username;
    homeDirectory = lib.mkDefault "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/${username}";
    stateVersion = "24.11";
  };
}
