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
  version = "1.5.6";

  src = fetchurl {
    url = "https://github.com/GopeedLab/gopeed/releases/download/v${version}/Gopeed-v${version}-linux-amd64.deb";
    hash = "sha256-PdSR/9K9x+I6COobFaYYKmfX6GzjZq4KuOwqSsS1R3Y=";
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
    libappindicator
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
    libappindicator
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
    description = "A modern download manager that supports all platforms.  Built with Golang and Flutter";
    license = licenses.gpl3Only;
    platforms = ["x86_64-linux"];
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    maintainers = with lib.maintainers; [aucub];
  };
}
