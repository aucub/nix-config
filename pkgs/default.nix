pkgs: {
  navicat = pkgs.callPackage ./navicat.nix { };
  damask = pkgs.callPackage ./damask.nix { };
  hiddify-next = pkgs.callPackage ./hiddify-next.nix { };
  mihomo-party = pkgs.callPackage ./mihomo-party.nix { };
}
