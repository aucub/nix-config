pkgs: {
  # https://www.navicat.com/en/products/navicat-premium-release-note
  navicat-premium = pkgs.callPackage ./navicat-premium.nix { language = "cs"; };
  warp-plus = pkgs.callPackage ./warp-plus.nix { };
  damask = pkgs.callPackage ./damask.nix { };
}
