# 自定义包,可以使用 'nix build .#example' 构建

pkgs:
{
  # example = pkgs.callPackage ./example { };
  vimix-cursor-theme = pkgs.callPackage ./vimix-cursor-theme { };
  # Gopeed = pkgs.callPackage ./Gopeed { };
}
