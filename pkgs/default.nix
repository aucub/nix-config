# 自定义包,可以使用'nix build .#example'或'nix-build -A example'来构建它们

{ pkgs ? (import ../nixpkgs.nix) { } }:
{
  # example = pkgs.callPackage ./example { };
  vimix-cursor-theme = pkgs.callPackage ./vimix-cursor-theme { };
}
