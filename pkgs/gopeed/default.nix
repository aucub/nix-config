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
  makeWrapper,
  udev,
  autoPatchelfHook,
  libayatana-indicator,
  ayatana-ido,
}:
stdenv.mkDerivation rec {
  pname = "gopeed";
  version = "1.5.1";

  src = fetchurl {
    url = "https://github.com/GopeedLab/gopeed/releases/download/v${version}/Gopeed-v${version}-linux-amd64.deb";
    hash = "sha256-XwB3+NtjeCqg3vHit4FRRpfNA65afH1Yc0QjIananqw=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    (wrapGAppsHook.override {inherit makeWrapper;})
    dpkg
  ];

  runtimeDependencies = [
    at-spi2-core
    gtk3
    cairo
    harfbuzz
    pango
    libepoxy
    libayatana-appindicator
    libdbusmenu
    libayatana-indicator
    ayatana-ido
  ];

  installPhase = ''
        runHook preInstall

    mkdir -p $out/bin
    cp -r opt $out/opt
    cp -r usr/share $out/share
        substituteInPlace $out/share/applications/gopeed.desktop \
          --replace "/opt/gopeed/gopeed" "$out/bin/gopeed" \
          --replace "/usr/share" "$out/share"
        ln -s $out/opt/gopeed/gopeed $out/gopeed/gopeed

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
