{ ... }:
{
  additions = final: _prev: import ../pkgs final.pkgs;
  modifications = final: prev: {
    orchis-theme = prev.orchis-theme.overrideAttrs (oldAttrs: {
      installPhase = ''
        runHook preInstall
        bash install.sh -d $out/share/themes -t default green --tweaks solid macos compact black primary submenu nord
        runHook postInstall
      '';
      src = prev.fetchFromGitHub {
        repo = "Orchis-theme";
        owner = "vinceliuice";
        rev = "d067106f77710a41c072995fe139f56844363da2";
        hash = "sha256-rgbqVU2tKLnp+ZQpLTthpo9vPFRkGuayJCADrI2R1ls=";
      };
    });
  };
}
