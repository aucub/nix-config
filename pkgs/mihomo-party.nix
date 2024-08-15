{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  cairo,
  xorg,
  libxkbcommon,
  mesa,
  expat,
  alsa-lib,
  at-spi2-core,
  libdrm,
  nss,
  cups,
  gtk3,
  pango,
  libva,
  libvdpau,
  systemd,
  glib,
  wrapGAppsHook3,
  libGL,
}:
let
  pname = "mihomo-party";
  version = "0.5.4";
  src = fetchurl {
    url = "https://github.com/pompurin404/mihomo-party/releases/download/v${version}/mihomo-party-linux-${version}-amd64.deb";
    sha256 = "29aAH8fTw141U1AXgVupSzQYh4jHx9H6IyA46O6sR4Q=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  dontBuild = true;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
    makeWrapper
  ];

  buildInputs = [
    cairo
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
    libxkbcommon
    expat
    alsa-lib
    at-spi2-core
    stdenv.cc.cc.lib
    libva
    libvdpau
    libdrm
    mesa.drivers
    at-spi2-core
    nss
    cups
    gtk3
    pango
    glib
    libGL
  ];

  runtimeDependencies = map lib.getLib [ systemd ];

  unpackPhase = ''
    runHook preUnpack

      dpkg-deb -x ${src} $out/

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mv $out/opt/* -t $out
    rm -r $out/opt
    mv $out/usr/share $out/
    rm -r $out/usr
    chmod +x $out/mihomo-party/mihomo-party
    chmod +x $out/mihomo-party/resources/sidecar/mihomo
    chmod +x $out/mihomo-party/resources/sidecar/mihomo-alpha
    patchelf --set-rpath ${libGL}/lib:$out/mihomo-party $out/mihomo-party/mihomo-party
    mkdir $out/bin
    makeWrapper $out/mihomo-party/mihomo-party $out/bin/mihomo-party \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libGL
          mesa.drivers
          glib
        ]
      }"
    substituteInPlace $out/share/applications/mihomo-party.desktop \
      --replace "Exec=/opt/mihomo-party/mihomo-party %U" "Exec=$out/bin/mihomo-party %U"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Another Mihomo GUI";
    homepage = "https://github.com/pompurin404/mihomo-party";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ aucub ];
    mainProgram = "mihomo-party";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
