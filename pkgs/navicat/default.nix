{
  stdenv,
  fetchurl,
  makeDesktopItem,
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
}: let
  pname = "navicat";
  version = "17.0.2";
  src = fetchurl {
    url = "https://dn.navicat.com/download/navicat17-premium-en-x86_64.AppImage";
    sha256 = "53580b0099c7209a914c4ca89becb16f1812c67849992ec83ce28863f988db84";
  };
  appimageContents = appimageTools.extractType2 {inherit pname version src;};
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
      sed -i '/^LD_LIBRARY_PATH=/ s|$|:${libGL}/lib:${glib}/lib:${glibc}/lib:${pango}/lib:${harfbuzz}/lib:${fontconfig}/lib:${libX11}/lib:${freetype}/lib:${e2fsprogs}/lib:${expat}/lib:${p11-kit}/lib:${libxcb}/lib:${libgpg-error}/lib|' $out/AppRun
      ln -s $out/AppRun $out/bin/${pname}
      install -Dm644 $out/navicat.desktop $out/share/applications/navicat.desktop
      cp -a $out/usr/share/icons $out/share/
    '';

    meta = with lib; {
      homepage = "https://navicat.com";
      description = "Navicat Premium is a multi-connection database development tool";
      platforms = ["x86_64-linux"];
      license = licenses.unfree;
      sourceProvenance = with sourceTypes; [binaryNativeCode];
      maintainers = with maintainers; [aucub];
    };
  }
