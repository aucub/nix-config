{ ... }:
{
  additions = final: _prev: import ../pkgs final.pkgs;
  modifications = final: prev: {
    orchis-theme = prev.orchis-theme.overrideAttrs (oldAttrs: {
      installPhase = ''
        runHook preInstall
        bash install.sh -d $out/share/themes -t default purple green --tweaks solid macos compact black primary submenu nord
        runHook postInstall
      '';
    });
    firefox-unwrapped = final.nur.repos.zzzsy.zen-browser.overrideAttrs (oldAttrs: {
      gtk3 = final.gtk3;
    });
  };
}
