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
  libdbusmenu-gtk3,
  libdbusmenu-gtk2,
  wrapGAppsHook,
  udev,
  autoPatchelfHook,
  libayatana-indicator,
  indicator-application-gtk3,
  indicator-application-gtk2,
  ayatana-ido,
  libappindicator,
  libindicator,
  libindicator-gtk3,
  libindicator-gtk2,
  libayatana-common,
  xxkb,
  pkg-config,
}:
stdenv.mkDerivation rec {
  pname = "gopeed";
  version = "1.3.13";

  src = fetchurl {
    url = "https://github.com/GopeedLab/gopeed/releases/download/v${version}/Gopeed-v${version}-linux-amd64.deb";
    hash = "sha256-5gy8a7QCcpGlLWqb8rd+A3PXSlN5f0CXacWOwf4lEfc=";
  };

  nativeBuildInputs = [dpkg pkg-config autoPatchelfHook];

  buildInputs = [wrapGAppsHook];

  autoPatchelfIgnoreMissingDeps = [
    "libayatana-appindicator3.so.1"
    "libayatana-indicator3.so.7"
    "libayatana-ido3-0.4.so.0"
    "libdbusmenu-glib.so.4"
  ];

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
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    maintainers = with maintainers; [aucub];
  };
}
