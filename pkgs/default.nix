pkgs: {
  navicat = pkgs.callPackage ./navicat.nix { };
  damask = pkgs.callPackage ./damask.nix { };
  flclash = pkgs.callPackage ./flclash.nix { };
  warp-plus = pkgs.callPackage ./warp-plus.nix { };
}
