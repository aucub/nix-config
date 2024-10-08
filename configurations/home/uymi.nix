{
  flake,
  pkgs,
  lib,
  specialArgs ? {
    useGlobalPkgs = false;
  },
  ...
}:
let
  useGlobalPkgs = specialArgs.useGlobalPkgs or false;
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

  nixpkgs =
    if !useGlobalPkgs then
      {
        config.allowUnfree = true;
        overlays = [
          self.overlays.default
          inputs.nur.overlay
          inputs.nix-alien.overlays.default
          inputs.nix-vscode-extensions.overlays.default
        ];
      }
    else
      { };

  home = {
    username = username;
    homeDirectory = lib.mkDefault "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/${username}";
    stateVersion = "24.11";
  };
}
