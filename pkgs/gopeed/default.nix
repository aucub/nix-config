{
  dpkg,
  fetchurl,
  glibc,
  gtk3,
  lib,
  libayatana-appindicator,
  stdenv,
  at-spi2-core,
  cairo,
  harfbuzz,
  pango,
  libepoxy,
  libdbusmenu,
  wrapGAppsHook,
  udev,
  autoPatchelfHook,
  libayatana-indicator,
  ayatana-ido,
}:
stdenv.mkDerivation rec {
  pname = "gopeed";
  version = "1.3.12";

  src = fetchurl {
    url = "https://github.com/GopeedLab/gopeed/releases/download/v${version}/Gopeed-v${version}-linux-amd64.deb";
    hash = "sha256-XwB3+NtjeCqg3vHit4FRRpfNA65afH1Yc0QjIananqw=";
  };

  nativeBuildInputs = [dpkg];

  buildInputs = [wrapGAppsHook];

  unpackCmd = "dpkg-deb -x $curSrc source";

  installPhase = ''
    runHook preInstall

      mv usr $out
      substituteInPlace $out/share/applications/gopeed.desktop \
        --replace "/usr" $out

      runHook postInstall
  '';

  meta = with lib; {
    description = "Gopeed (full name Go Speed), a high-speed downloader developed by Golang + Flutter, supports (HTTP, BitTorrent, Magnet) protocol, and supports all platforms.";
    homepage = "https://github.com/GopeedLab/gopeed";
    license = licenses.gpl3;
    platforms = lib.platforms.linux;
    sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    maintainers = with maintainers; [aucub];
  };
}
