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
  qt6,
  libxcrypt,
}:
stdenv.mkDerivation rec {
  pname = "navicat-premium";
  version = "17.1.7";

  src = appimageTools.extractType2 {
    inherit pname version;
    src = fetchurl {
      url = "https://dn.navicat.com/download/navicat17-premium-cs-x86_64.AppImage";
      hash = "sha256-CPni2kOL6O3NGKZR92FfLGsId4t9FBhsL3iQ7UsqqV0=";
    };
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    qt6.wrapQtAppsHook
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
    qt6.qtbase
  ];

  installPhase = ''
    runHook preInstall

    chmod 755 ./usr
    cp -r ./usr $out
    mkdir -p $out/usr
    ln -s $out/lib $out/usr/lib
    rm $out/lib/libselinux.so.1
    ln -s ${libselinux}/lib/libselinux.so.1 $out/lib/libselinux.so.1
    rm $out/lib/glib/libglib-2.0.so.0
    ln -s ${glib.out}/lib/libglib-2.0.so.0 $out/lib/glib/libglib-2.0.so.0

    runHook postInstall
  '';

  dontWrapQtApps = true;

  preFixup = ''
    patchelf --replace-needed libcrypt.so.1 \
      ${libxcrypt}/lib/libcrypt.so.2 $out/lib/pq-g/libpq.so.5.5
    patchelf --replace-needed libcrypt.so.1 \
      ${libxcrypt}/lib/libcrypt.so.2 $out/lib/pq-g/libpq_ce.so.5.5
    patchelf --replace-needed libselinux.so.1 \
      ${libselinux}/lib/libselinux.so.1 $out/lib/pq-g/libpq.so.5.5
    wrapProgram $out/bin/navicat \
      ''${qtWrapperArgs[@]} \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
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
        ]
      }:$out/lib \
      --set QT_PLUGIN_PATH $out/plugins \
      --set QT_QPA_PLATFORM xcb \
      --set QT_STYLE_OVERRIDE Fusion \
      --chdir $out
  '';

  meta = {
    homepage = "https://www.navicat.com/products/navicat-premium";
    changelog = "https://www.navicat.com/products/navicat-premium-release-note";
    description = "Database development tool that allows you to simultaneously connect to many databases";
    mainProgram = "navicat";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ aucub ];
    platforms = [ "x86_64-linux" ];
  };
}
