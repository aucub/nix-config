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
  makeWrapper,
  udev,
  autoPatchelfHook,
  libayatana-indicator,
  ayatana-ido,
  libappindicator,
  libindicator,
}:
stdenv.mkDerivation rec {
  pname = "gopeed";
  version = "1.5.1";

  src = fetchurl {
    url = "https://github.com/GopeedLab/gopeed/releases/download/v${version}/Gopeed-v${version}-linux-amd64.deb";
    hash = "sha256-4/c4KiGKNBSphlX89uYU6SuK7g6OiCI4Gor825ggkrw=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    (wrapGAppsHook.override {inherit makeWrapper;})
    dpkg
  ];

  buildInputs = [
    at-spi2-core
    glib
    gtk3
    libayatana-appindicator
    libdbusmenu
    libayatana-indicator
    ayatana-ido
  ];

  runtimeDependencies = [
    at-spi2-core
    gtk3
    cairo
    gdk-pixbuf
    harfbuzz
    pango
    libepoxy
    libayatana-appindicator
    libdbusmenu
    libayatana-indicator
    ayatana-ido
  ];
  postPatch = ''
    substituteInPlace --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  installPhase = ''
        runHook preInstall

    mkdir -p $out/bin
    cp -r opt $out/opt
    cp -r usr/share $out/share
    ln -s $out/opt/gopeed/gopeed $out/bin/gopeed

        runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://gopeed.com";
    description = "A modern download manager that supports all platforms. Built with Golang and Flutter.";
    license = licenses.gpl3;
    platforms = ["x86_64-linux"];
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    maintainers = with lib.maintainers; [aucub];
  };
}
