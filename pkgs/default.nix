pkgs: {
  navicat = pkgs.callPackage ./navicat.nix { };
  damask = pkgs.callPackage ./damask.nix { };
  warp-plus = pkgs.callPackage ./warp-plus.nix { };
  tinysparql = pkgs.callPackage ./tinysparql.nix { };
}
