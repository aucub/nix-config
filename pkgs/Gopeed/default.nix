{ dpkg, fetchurl, glibc, gtk3, lib, libayatana-appindicator, stdenv
, at-spi2-core, cairo, harfbuzz, pango, libepoxy, libdbusmenu, wrapGAppsHook
, udev, autoPatchelfHook, libayatana-indicator, ayatana-ido }:

stdenv.mkDerivation rec {
  pname = "Gopeed";
  version = "1.3.12";

  src = fetchurl {
    url =
      "https://github.com/GopeedLab/gopeed/releases/download/v${version}/Gopeed-v${version}-linux-amd64.deb";
    hash = "sha256-XwB3+NtjeCqg3vHit4FRRpfNA65afH1Yc0QjIananqw=";
  };

  nativeBuildInputs = [ dpkg wrapGAppsHook autoPatchelfHook ];

  buildInputs = [ stdenv.cc.cc ];

  runtimeDependencies = [ (lib.getLib udev) libayatana-appindicator ];

  installPhase = ''
    runHook preInstall

      mkdir -p $out/bin
      cp -r usr/local/lib/gopeed $out/opt
      cp -r usr/share $out/share
      substituteInPlace $out/share/applications/gopeed.desktop \
        --replace "/opt/gopeed" "$out/bin/gopeed" \
        --replace "/usr/share" "$out/share"
      ln -s $out/opt/gopeed/gopeed $out/bin/gopeed

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
