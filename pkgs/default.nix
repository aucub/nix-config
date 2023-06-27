# 自定义软件包，可以类似于来自 nixpkgs 的软件包进行定义
# 可以构建 'nix build .#example' 或 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { } }: {
  # example = pkgs.callPackage ./example { };
  environment = pkgs.callPackage ./environment { };
  fonts = pkgs.callPackage ./fonts { };
  hardware = pkgs.callPackage ./hardware { };
  hyprland = pkgs.callPackage ./hyprland { };
}

