pkgs: {
  navicat-premium = pkgs.callPackage ./navicat-premium.nix { language = "cs"; };
  warp-plus = pkgs.callPackage ./warp-plus.nix { };
  damask = pkgs.callPackage ./damask.nix { };
}
