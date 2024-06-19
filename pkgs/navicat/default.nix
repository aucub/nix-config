{
  fetchurl,
  makeWrapper,
  appimageTools,
  lib,
  libGL,
  autoPatchelfHook,
  wrapGAppsHook,
  glib,
  glibc,
  pango,
  harfbuzz,
  fontconfig,
  libX11,
  freetype,
  e2fsprogs,
  expat,
  p11-kit,
  libxcb,
  libgpg-error,
}:
let
  pname = "navicat";
  version = "17.0.5";
  src = fetchurl {
    url = "https://dn.navicat.com/download/navicat17-premium-cs-x86_64.AppImage";
    sha256 = "6wTykuH9atSELDWEiiWIv1ptdZPca4UxcqPeRSxC4JQ=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  buildInputs = [
    libgpg-error
    libxcb
    p11-kit
    expat
    e2fsprogs
    freetype
    libX11
    fontconfig
    harfbuzz
    pango
    glibc
    glib
    libGL
    autoPatchelfHook
    wrapGAppsHook
    makeWrapper
  ];

  extraInstallCommands = ''
    rm -r $out/bin
    cp -a ${appimageContents}/* $out/
    mkdir -p $out/bin
    sed -i '1s|.*|#!/usr/bin/env bash|' $out/AppRun
    sed -i '/^LD_LIBRARY_PATH=/ s|$|:${libGL}/lib:${glib}/lib:${glib.out}/lib:${glibc}/lib:${pango}/lib:${pango.out}/lib:${harfbuzz}/lib:${fontconfig}/lib:${harfbuzz.out}/lib:${fontconfig.lib}/lib:${libX11}/lib:${freetype}/lib:${e2fsprogs}/lib:${expat}/lib:${p11-kit}/lib:${libxcb}/lib:${libgpg-error}/lib:${e2fsprogs.out}/lib:${expat.out}/lib:${p11-kit.out}/lib:${libxcb.out}/lib:${libgpg-error.out}/lib|' $out/AppRun
    ln -s $out/AppRun $out/bin/${pname}
    install -Dm644 $out/navicat.desktop $out/share/applications/navicat.desktop
    cp -a $out/usr/share/icons $out/share/
  '';

  meta = with lib; {
    homepage = "https://www.navicat.com.cn/products/navicat-premium-release-note";
    description = "Navicat Premium is a multi-connection database development tool";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ aucub ];
  };
}
