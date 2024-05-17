{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "navicat";
  version = "17.0.2";

  src = fetchurl {
    url = "https://dn.navicat.com/download/navicat17-premium-en-x86_64.AppImage";
    sha256 = "53580b0099c7209a914c4ca89becb16f1812c67849992ec83ce28863f988db84";
  };

  nativeBuildInputs = [autoPatchelfHook makeWrapper];

  unpackPhase = ''
    runHook preUnpack

    mkdir -p $sourceRoot
    cp ${src} $sourceRoot/
    chmod +x $sourceRoot/${pname}-${version}.AppImage
    $sourceRoot/${pname}-${version}.AppImage --appimage-extract
    mv squashfs-root $sourceRoot/extracted

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -D -m755 $sourceRoot/extracted/AppRun $out/bin/${pname}
    mkdir -p $out/opt/${pname}
    cp -r $sourceRoot/extracted/usr $out/opt/${pname}/

    mkdir -p $out/share/applications
    install -Dm644 ${desktopFile} $out/share/applications/${pname}.desktop

    mkdir -p $out/share/icons/hicolor/256x256/apps
    ln -s $out/opt/${pname}/usr/share/icons/hicolor/256x256/apps/navicat-icon.png $out/share/icons/hicolor/256x256/apps/navicat17.png

    wrapProgram $out/bin/${pname} --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [stdenv.cc.cc.lib]}

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = "https://navicat.com";
    description = "Navicat Premium is a multi-connection database development tool.";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; ["aucub"];
  };
}
