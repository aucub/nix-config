{ flake, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
  packages = self + /packages;
in
self: prev: {
  damask = self.callPackage "${packages}/damask.nix" { };
  navicat-premium = self.callPackage "${packages}/navicat-premium.nix" { language = "cs"; };
  warp-plus = self.callPackage "${packages}/warp-plus.nix" { };
  orchis-theme = prev.orchis-theme.overrideAttrs (oldAttrs: {
    installPhase = ''
      runHook preInstall

      bash install.sh -d $out/share/themes -t default green --tweaks solid macos compact black primary submenu nord

      runHook postInstall
    '';
    src = prev.fetchFromGitHub {
      repo = "Orchis-theme";
      owner = "vinceliuice";
      rev = "6cda1476f059a0f96b475e80112f333e1ba66a80";
      hash = "sha256-Oxtlu67OFGdj1GkYiGcUdsdvt/KWyuAhsABzBTOkBes=";
    };
  });
  nautilus = prev.nautilus.overrideAttrs (oldAttrs: {
    postPatch =
      (oldAttrs.postPatch or "")
      + ''
        sed -i '/static void\s*action_send_email/,/^\}/d' src/nautilus-files-view.c
        sed -i '/\.name = "send-email"/d' src/nautilus-files-view.c
        sed -i '/action = g_action_map_lookup_action.*(view_action_group, "send-email");/,/^\s*}$/d' src/nautilus-files-view.c
      '';
  });
  glycin-loaders = prev.glycin-loaders.overrideAttrs (oldAttrs: rec {
    version = "1.1.1";
    src = prev.fetchurl {
      url = "mirror://gnome/sources/glycin/${prev.lib.versions.majorMinor version}/glycin-${version}.tar.xz";
      hash = "sha256-Vg7kIWfB7SKCZhjmHYPkkUDbW/R6Zam6js4s1z0qSqg=";
    };
    buildInputs =
      oldAttrs.buildInputs
      ++ (with prev; [
        lcms2
        librsvg
      ]);
    mesonFlags = [
      "-Dglycin-loaders=true"
      "-Dlibglycin=false"
      "-Dvapi=false"
    ];
  });
  libsecret = prev.libsecret.overrideAttrs (oldAttrs: {
    doCheck = false;
  });
}
