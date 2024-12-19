{ flake, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
  packages = self + /packages;
in
self: prev: {
  navicat-premium = self.callPackage "${packages}/navicat-premium.nix" { };
  firefox-gnome-theme = self.callPackage "${packages}/firefox-gnome-theme.nix" { };
  orchis-theme = prev.orchis-theme.overrideAttrs (oldAttrs: {
    installPhase = ''
      runHook preInstall

      bash install.sh -d $out/share/themes -t default green --tweaks solid macos compact black primary submenu nord

      runHook postInstall
    '';
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
  fhs = (
    let
      base = prev.appimageTools.defaultFhsEnvArgs;
    in
    prev.buildFHSEnv (
      base
      // {
        name = "fhs";
        targetPkgs =
          pkgs:
          (base.targetPkgs pkgs)
          ++ (with pkgs; [
            fish
          ])
          ++ (with pkgs; [
            udev
            alsa-lib
            icu
          ])
          ++ (with pkgs.xorg; [
            libX11
            libXcursor
            libXrandr
          ]);
        profile = "export FHS=1";
        runScript = "fish";
        extraOutputsToInstall = [ "dev" ];
      }
    )
  );
}
