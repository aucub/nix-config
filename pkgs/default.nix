# 使用 'nix build .#example' 构建
{pkgs, ...}: {
  # example = pkgs.callPackage ./example { };
  gopeed = pkgs.callPackage ./gopeed {};
  clash-verge = pkgs.callPackage ./clash-verge {};
  hiddify = pkgs.callPackage ./hiddify {};
}
