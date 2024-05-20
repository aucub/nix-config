{
  stdenv,
  fetchurl,
  makeDesktopItem,
  makeWrapper,
}:
stdenv.mkDerivation {
  pname = "navicat";
  version = "17.0.2";

  src = fetchurl {
    url = "https://dn.navicat.com/download/navicat17-premium-en-x86_64.AppImage";
    sha256 = "53580b0099c7209a914c4ca89becb16f1812c67849992ec83ce28863f988db84";
  };

  unpackPhase = "true";

  installPhase = ''
     mkdir -p $out/bin
     mkdir -p $out/share/applications
     mkdir -p $out/share/icons

     # Extract AppImage contents
     chmod +x AppRun
    ./AppRun --appimage-extract

     # Install navicat executable
     install -D usr/bin/navicat $out/bin/navicat

     # Install desktop file
     install -D navicat.desktop $out/share/applications/navicat.desktop

     # Install icon
     install -D navicat-icon.png $out/share/icons/navicat-icon.png

     # Create wrapper script
     wrapProgram $out/bin/navicat --set LD_LIBRARY_PATH ${lib.makeLibraryPath [stdenv.cc.cc.lib]}:$out/lib:$out/usr/lib
  '';

  desktopItem = makeDesktopItem {
    name = "navicat";
    exec = "navicat";
    icon = "navicat-icon";
    type = "Application";
    categories = "Development";
  };

  meta = {
    homepage = "https://navicat.com";
    description = "Navicat Premium is a multi-connection database development tool";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; ["aucub"];
  };
}
