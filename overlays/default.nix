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
    gitleaks = prev.gitleaks.overrideAttrs (oldAttrs: rec {
      version = "8.19.2";
      src = prev.fetchFromGitHub {
        owner = "zricethezav";
        repo = "gitleaks";
        rev = "refs/tags/v${version}";
        hash = "sha256-VC8Bf6jcxXdBws7IParh9Srk34JiYVx5Tk2LLilrNJ4=";
      };
    });
  };
}
