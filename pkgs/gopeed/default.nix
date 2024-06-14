{
  dpkg,
  fetchurl,
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
  autoPatchelfHook,
  libayatana-indicator,
  ayatana-ido,
  libappindicator,
}:
stdenv.mkDerivation rec {
  pname = "gopeed";
  version = "1.5.7";

  src = fetchurl {
    url = "https://github.com/GopeedLab/gopeed/releases/download/v${version}/Gopeed-v${version}-linux-amd64.deb";
    sha256 = "5484719fe8879094b3957fd10780ec087801e3ea46337ac9d921396402701b01";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    wrapGAppsHook
  ];

  buildInputs = [
    at-spi2-core
    glib
    gtk3
    libayatana-appindicator
    libdbusmenu
    libayatana-indicator
    ayatana-ido
    libappindicator
    cairo
    gdk-pixbuf
    harfbuzz
    pango
    libepoxy
  ];

  propagatedBuildInputs = [
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
    libappindicator
  ];

  postPatch = ''
    substituteInPlace --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  installPhase = ''
    runHook preInstall
    dpkg -x ${src} $out
    mkdir -p $out/bin
    ln -s $out/opt/${pname}/${pname} $out/bin/${pname}
    mv $out/usr/share $out/share
    rm -rf $out/usr
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://gopeed.com";
    description = "A modern download manager that supports all platforms. Built with Golang and Flutter";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ aucub ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
