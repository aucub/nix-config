{
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook,
  libappindicator,
  libayatana-indicator,
  libayatana-appindicator,
  libdbusmenu,
  ayatana-ido,
  libindicator,
  glibc,
  gtk3,
  lib,
  glib,
  libepoxy,
  at-spi2-core,
  cairo,
  gdk-pixbuf,
  harfbuzz,
  pango,
  udev,
  autoPatchelfHook,
}:
stdenv.mkDerivation rec {
  pname = "gopeed";
  version = "1.5.1";

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
    libindicator
    glibc
    gtk3
    lib
    glib
    libepoxy
    at-spi2-core
    cairo
    gdk-pixbuf
    harfbuzz
    pango
    udev
  ];

  unpackCmd = "dpkg-deb -x $curSrc source";

  postPatch = ''
    substituteInPlace $src/source/DEBIAN/control \
      --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  installPhase = ''
    runHook preInstall

    mv source/usr $out
    substituteInPlace $out/share/applications/gopeed.desktop \
      --replace "/usr" $out

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Gopeed (full name Go Speed), a high-speed downloader developed by Golang + Flutter, supports (HTTP, BitTorrent, Magnet) protocol, and supports all platforms.";
    homepage = "https://github.com/GopeedLab/gopeed";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [aucub];
  };
}
