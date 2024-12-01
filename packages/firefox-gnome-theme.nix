{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttr: {
  pname = "firefox-gnome-theme";
  version = "133";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "firefox-gnome-theme";
    rev = "c1d082e47cb38b9e8d8d6899398f3bae51a72c34"; # "refs/tags/v${finalAttr.version}";
    hash = "sha256-Hf2NK58bTV1hy6FxvKpyNzm59tyMPzDjc8cGcWiTLyQ=";
  };

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';

  meta = {
    description = "GNOME theme for Firefox";
    homepage = "https://github.com/rafaelmardojai/firefox-gnome-theme";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.all;
  };
})
