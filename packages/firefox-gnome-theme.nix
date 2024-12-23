{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttr: {
  pname = "firefox-gnome-theme";
  version = "133.1";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "firefox-gnome-theme";
    tag = "v${finalAttr.version}";
    hash = "sha256-onO+zd9ssgsLC5ax3UWPZ41DcZPkxdXT8JmmjDkw944=";
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
