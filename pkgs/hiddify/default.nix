{
  lib,
  stdenv,
  appimageTools,
  fetchzip,
}: let
  pname = "hiddify";
  version = "0.11.1";

  hiddify-src = stdenv.mkDerivation {
    name = "hiddify-src";

    src = fetchzip {
      stripRoot = false;
      url = "https://github.com/hiddify/hiddify-next/releases/download/v${version}/hiddify-linux-x64.zip";
      hash = "sha256-Qq9HsgIKJysmPQB5T97gj3gIcZ1/XN7GC8uq0A2Z6cA=";
    };

    installPhase = ''
      cp hiddify-linux-x64.AppImage $out
    '';
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version;
    src = hiddify-src;
  };
in
  appimageTools.wrapType2 rec {
    inherit pname version;
    src = hiddify-src;

    extraInstallCommands = ''
      mv $out/bin/${pname}-${version} $out/bin/${pname}
      install -m 444 -D ${appimageContents}/hiddify.desktop $out/share/applications/hiddify.desktop
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/128x128/apps/hiddify.png $out/share/icons/hicolor/128x128/apps/hiddify.png
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/256x256/apps/hiddify.png $out/share/icons/hicolor/256x256/apps/hiddify.png
      substituteInPlace $out/share/applications/hiddify.desktop \
        --replace 'Exec=' 'Exec=env '
    '';

    meta = with lib; {
      description = "A multi-platform client based on Sing-box that serves as a universal proxy tool-chain";
      homepage = "https://github.com/hiddify/hiddify-next";
      sourceProvenance = with sourceTypes; [binaryNativeCode];
      license = licenses.cc-by-nc-sa-40;
      maintainers = with maintainers; [aucub];
      platforms = ["x86_64-linux"];
    };
  }
