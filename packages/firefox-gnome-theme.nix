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
    rev = "aa9b67045fcdec7ae045b36d7a41b36b3463b842"; # "refs/tags/v${finalAttr.version}";
    hash = "sha256-Q8W1YlsZmxhUaXLOJhPCeEzKqaqmspT9VKYZxn5Kh40=";
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
