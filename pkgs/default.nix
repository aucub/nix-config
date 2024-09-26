pkgs: {
  navicat-premium = pkgs.callPackage ./navicat-premium.nix { language = "cs"; };
  damask = pkgs.callPackage ./damask.nix { };
  warp-plus = pkgs.callPackage ./warp-plus.nix { };
}
