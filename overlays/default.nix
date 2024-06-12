{
  inputs,
  pkgs,
  ...
}: {
  additions = final: _prev: import ../pkgs final.pkgs;
  modifications = final: prev: {
    orchis-theme = prev.orchis-theme.overrideAttrs (oldAttrs: {
      installPhase = ''
        runHook preInstall
        bash install.sh -d $out/share/themes -t default purple green --tweaks solid macos compact black primary submenu nord
        runHook postInstall
      '';
    });
    upower-conf = ./org.freedesktop.UPower.conf;
    upower = prev.upower.overrideAttrs (oldAttrs: {
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs.xmlstarlet];
      postInstall =
        oldAttrs.postInstall
        + ''
          xmlstarlet ed -L \
          -r "//policy/allow[@send_destination='org.freedesktop.UPower.KbdBacklight' and @send_interface='org.freedesktop.DBus.Properties']" -v "deny" \
          -r "//policy/allow[@send_destination='org.freedesktop.UPower' and @send_interface='org.freedesktop.UPower.KbdBacklight']" -v "deny" \
          $out/share/dbus-1/system.d/org.freedesktop.UPower.conf
        '';
    });
  };

  # unstable-small-packages = final: _prev: {
  #   unstable-small = import inputs.nixpkgs-unstable-small {
  #     system = final.system;
  #     config.allowUnfree = true;
  #   };
  # };
}
