{
  fetchurl,
  appimageTools,
  lib,
  libGL,
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
  stdenv,
  cjson,
  libxcrypt-legacy,
  curl,
  makeWrapper,
  autoPatchelfHook,
  libxkbcommon,
  libselinux,
}:

let
  pname = "navicat";
  version = "17.0.5";
  src = fetchurl {
    url = "https://dn.navicat.com/download/navicat17-premium-cs-x86_64.AppImage";
    sha256 = "6wTykuH9atSELDWEiiWIv1ptdZPca4UxcqPeRSxC4JQ=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
  ldLibraryPath = lib.makeLibraryPath [
    libGL
    glib
    glibc
    pango
    harfbuzz
    fontconfig
    libX11
    freetype
    e2fsprogs
    expat
    p11-kit
    libxcb
    libgpg-error
    libxkbcommon
    libselinux
  ];
in
stdenv.mkDerivation {
  inherit pname version;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

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
    cjson
    curl
    libxcrypt-legacy
    libxkbcommon
    libselinux
  ];

  dontUnpack = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    cp -a ${appimageContents}/usr $out/

    chmod -R u+rwX,go+rX,go-w $out
    chmod 755 $out/bin/navicat

    mkdir -p $out/usr
    ln -s $out/lib $out/usr/lib

    runHook postInstall
  '';

  preFixup = ''
    wrapProgram $out/bin/navicat \
    --prefix LD_LIBRARY_PATH : "${ldLibraryPath}:$out/lib/oci:$out/lib/obci:$out/lib/pq-g:$out/lib:~/.config/navicat/Premium/lib/sqlite:~/.config/navicat/Premium/lib/oci" \
    --set QT_PLUGIN_PATH "$out/plugins" \
    --set QT_QPA_PLATFORM xcb \
    --set QT_STYLE_OVERRIDE Fusion \
    --chdir "$out"
  '';

  meta = with lib; {
    homepage = "https://www.navicat.com.cn/products/navicat-premium-release-note";
    description = "Navicat Premium is a database development tool";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ aucub ];
  };
}
