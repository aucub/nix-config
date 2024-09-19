{
  lib,
  fetchurl,
  stdenv,
  autoPatchelfHook,
  dpkg,
  makeWrapper,
  at-spi2-atk,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  harfbuzz,
  pango,
  libayatana-appindicator,
  keybinder3,
}:
let
  pname = "flclash";
  version = "0.8.61";
  src = fetchurl {
    url = "https://github.com/chen08209/FlClash/releases/download/v${version}/FlClash-${version}-linux-amd64.deb";
    sha256 = "xNzw+W6sGa55PPQ1txBjVjeu2zW1C0aW8pynZBd9LPc=";
  };
in
stdenv.mkDerivation {
  inherit pname version;

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc
    at-spi2-atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    pango
    libayatana-appindicator
    keybinder3
  ];

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x ${src} ./

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    mv usr/* -t $out

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup
    makeWrapper $out/share/FlClash/FlClash $out/bin/FlClash \
    --prefix LD_LIBRARY_PATH : "$out/share/FlClash/lib" \
    --chdir "$out/share/FlClash"
    runHook postFixup
  '';

  meta = {
    homepage = "https://github.com/chen08209/FlClash";
    description = "A multi-platform proxy client based on ClashMeta, simple and easy to use, open-source and ad-free";
    maintainers = with lib.maintainers; [ aucub ];
    license = with lib.licenses; [ gpl3Only ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "FlClash";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
