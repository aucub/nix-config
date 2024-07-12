{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  cairo,
  gdk-pixbuf,
  glib,
  harfbuzz,
  at-spi2-core,
  gtk3,
  pango,
  libayatana-appindicator,
  libayatana-indicator,
  ayatana-ido,
  libdbusmenu,
  makeWrapper,
}:
let
  pname = "hiddify-next";
  version = "1.6.0.dev";
  src = fetchurl {
    url = "https://github.com/hiddify/hiddify-next/releases/download/v${version}/Hiddify-Debian-x64.deb";
    hash = "sha256-skn9QtwNcgYcuUAcEty4bM154QXrC8d4VQqjLnkIZtw=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  dontBuild = true;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  unpackPhase = ''
    runHook preUnpack

      dpkg-deb -x ${src} $out/

    runHook postUnpack
  '';

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    stdenv.cc.cc.lib
    harfbuzz
    at-spi2-core
    gtk3
    pango
    libayatana-appindicator
    libayatana-indicator
    ayatana-ido
    libdbusmenu
  ];

  installPhase = ''
    runHook preInstall
    mkdir $out/bin
    mv $out/usr/share/hiddify/* -t $out/bin
    rm -r $out/usr/share/hiddify
    mv $out/usr/share $out/
    rm -r $out/usr
    runHook postInstall
  '';

  preFixup = ''
    wrapProgram $out/bin/hiddify \
    --prefix LD_LIBRARY_PATH : "$out/bin/lib"
    wrapProgram $out/bin/HiddifyCli \
    --prefix LD_LIBRARY_PATH : "$out/bin/lib"
  '';

  meta = with lib; {
    description = "Multi-platform auto-proxy client";
    longDescription = ''
      Multi-platform auto-proxy client, supporting Sing-box, X-ray, TUIC, Hysteria, Reality, Trojan, SSH etc.
    '';
    homepage = "https://github.com/hiddify/hiddify-next";
    license = licenses.cc-by-nc-sa-40;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ aucub ];
    mainProgram = "hiddify";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
