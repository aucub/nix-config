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

    LD_LIBRARY_PATH = "/run/opengl-driver/lib:/run/opengl-driver-32/lib:${glib}/lib:${glibc}/lib:${glib.out}/lib:${pango.out}/lib:${harfbuzz.out}/lib:${fontconfig.lib}/lib:${libX11}/lib:${freetype}/lib:${e2fsprogs.out}/lib:${expat.out}/lib:${p11-kit.out}/lib:${libxcb.out}/lib:${libgpg-error.out}/lib";
    LIBGL_DRIVERS_PATH = "/run/opengl-driver/lib/dri";

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

    nativeBuildInputs = [
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
      # Remove existing $out/bin directory
      rm -r $out/bin

      # Copy appimageContents to $out
      cp -a ${appimageContents}/* $out/

      # Create new $out/bin directory
      mkdir -p $out/bin

      # Modify AppRun file's shebang line
      sed -i '1s|.*|#!/usr/bin/env bash|' $out/AppRun
      # Update LD_LIBRARY_PATH in AppRun
      sed -i '/^LD_LIBRARY_PATH=/ s|$|:/run/opengl-driver/lib:/run/opengl-driver-32/lib:${glib}/lib:${glibc}/lib:${glib.out}/lib:${pango.out}/lib:${harfbuzz.out}/lib:${fontconfig.lib}/lib:${libX11}/lib:${freetype}/lib:${e2fsprogs.out}/lib:${expat.out}/lib:${p11-kit.out}/lib:${libxcb.out}/lib:${libgpg-error.out}/lib|' $out/AppRun

      # Install AppRun to $out/bin and rename it
      ln -s $out/AppRun $out/bin/${pname}

      # Install navicat.desktop to the appropriate location
      install -Dm644 $out/navicat.desktop $out/share/applications/navicat.desktop

      # Copy icon files to $out/share/icons
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
