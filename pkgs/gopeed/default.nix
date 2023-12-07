{
  dpkg,
  fetchurl,
  glibc,
  gtk3,
  lib,
  glib,
  libayatana-appindicator,
  stdenv,
  at-spi2-core,
  cairo,
  gdk-pixbuf,
  harfbuzz,
  pango,
  libepoxy,
  libdbusmenu,
  wrapGAppsHook,
  udev,
  autoPatchelfHook,
  libayatana-indicator,
  ayatana-ido,
  libappindicator,
  libindicator,
}:
stdenv.mkDerivation rec {
  pname = "gopeed";
  version = "1.3.13";

  src = fetchurl {
    url = "https://github.com/GopeedLab/gopeed/releases/download/v${version}/Gopeed-v${version}-linux-amd64.deb";
    hash = "sha256-5gy8a7QCcpGlLWqb8rd+A3PXSlN5f0CXacWOwf4lEfc=";
  };

  nativeBuildInputs = [dpkg autoPatchelfHook];

  buildInputs = [
    wrapGAppsHook
    libappindicator
    libayatana-indicator
    libayatana-appindicator
    libdbusmenu
    ayatana-ido
  ];

  unpackCmd = "dpkg-deb -x $curSrc source";

  postPatch = ''
    substituteInPlace --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

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
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    maintainers = with maintainers; [aucub];
  };
}