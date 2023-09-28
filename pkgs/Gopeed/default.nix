{ dpkg, fetchurl, glibc, gtk3, lib, libayatana-appindicator, stdenv
, at-spi2-core, cairo, harfbuzz, pango, libepoxy, libdbusmenu
, libayatana-indicator, ayatana-ido }:

stdenvNoCC.mkDerivation rec {
  pname = "Gopeed";
  version = "1.3.12";

  src = fetchurl {
    url =
      "https://github.com/GopeedLab/gopeed/releases/download/v${version}/Gopeed-v${version}-linux-amd64.deb";
    hash = "";
  };

  nativeBuildInputs = [ dpkg ];

  runtimeDependencies = map lib.getLib [
    glibc
    gtk3
    lib
    libayatana-appindicator
    stdenv
    at-spi2-core
    cairo
    rubyPackages_3_3.gdk_pixbuf2
    harfbuzz
    pango
    libepoxy
    rubyPackages_3_3.glib2
    libdbusmenu
    libayatana-indicator
    ayatana-ido
  ];

  installPhase = ''
    runHook preInstall

      mkdir -p $out/bin
      cp -r opt $out/opt
      cp -r usr/share $out/share
      substituteInPlace $out/share/applications/Gopeed.desktop \
        --replace "/opt/Gopeed" "$out/bin/Gopeed" \
        --replace "/usr/share" "$out/share"
      ln -s $out/opt/Gopeed $out/bin/Gopeed

      runHook postInstall
  '';

  meta = with lib; {
    description =
      "Gopeed (full name Go Speed), a high-speed downloader developed by Golang + Flutter, supports (HTTP, BitTorrent, Magnet) protocol, and supports all platforms.";
    homepage = "https://github.com/GopeedLab/gopeed";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ aucub ];
  };
}
