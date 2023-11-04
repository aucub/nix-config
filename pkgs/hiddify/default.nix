{
 lib, stdenv, appimageTools, fetchurl 
}:
stdenv.mkDerivation rec {
  pname = "hiddify";
  version = "0.10.0";

  src = fetchurl {
    url = "https://github.com/hiddify/hiddify-next/releases/download/v${version}/hiddify-linux-x64.zip";
    hash = "sha256-b874ce0468570cd3e161bb1516318cbe49917bfcde18cc117a93d411cc623578";
  };

  appimageContents = appimageTools.extract { inherit pname version src.extract.hiddify-linux-x64.AppImage; };

  installPhase = appimageTools.wrapType2 rec {
    inherit pname version src meta;

    extraPkgs = p: [ p.ayatana-ido p.libayatana-appindicator p.libayatana-indicator p.libdbusmenu p.libepoxy ];

    extraInstallCommands = ''
      mv $out/bin/${pname}-${version} $out/bin/${pname}

      install -m 444 -D ${appimageContents}/org.localsend.localsend_app.desktop \
        $out/share/applications/${pname}.desktop
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=localsend_app' "Exec=$out/bin/localsend"

      install -m 444 -D ${appimageContents}/localsend.png \
        $out/share/icons/hicolor/256x256/apps/localsend.png
    '';
  };

  meta = with lib; {
    description = "A multi-platform client based on Sing-box that serves as a universal proxy tool-chain.";
    homepage = "https://github.com/hiddify/hiddify-next";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.cc-by-nc-sa-40;
    maintainers = with maintainers; [ aucub ];
    platforms = [ "x86_64-linux" ];
  };
}
