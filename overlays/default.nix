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
    nix-search-cli = prev.nix-search-cli.overrideAttrs (oldAttrs: {
      version = "0.2-unstable-2024-09-24";
      src = prev.fetchFromGitHub {
        owner = "peterldowns";
        repo = "nix-search-cli";
        rev = "7d6b4c501ee448dc2e5c123aa4c6d9db44a6dd12";
        hash = "sha256-YM1Lf7py79rU8aJE0PfQaMr5JWx5J1covUf1aCjRkc8=";
      };
    });
  };
}
