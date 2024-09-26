{
  lib,
  fetchFromGitHub,
  electron,
  mihomo,
  musl,
  mesa,
  pnpm,
  makeWrapper,
  stdenv,
  nodejs,
  autoPatchelfHook,
  nss,
  nspr,
  dbus,
  atk,
  cups,
  gtk3,
  fetchurl,
  cairo,
  xorg,
  libxkbcommon,
  expat,
  alsa-lib,
  at-spi2-core,
  libdrm,
  pango,
  libva,
  libvdpau,
  systemd,
  glib,
  wrapGAppsHook3,
  libGL,
  libjpeg,
  libXcomposite,
  libXdamage,
  libXfixes,
  libXrandr,
  libglvnd,
  libpng,
  alsaLib,
  pulseaudio,
  flac,
  libxslt,
  fetchzip,
}:
let
  meta-rules-dat_hash = "4c06bbfe8de75f18bee1aea157297fda16081766";
  Sub-Store_hash = "cd224d30a2bf13929b837b45e6b1445d9d73fc03";
  meta-rules-dat_url = "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/${meta-rules-dat_hash}/";
  Sub-Store_url = "https://raw.githubusercontent.com/sub-store-org/Sub-Store/${Sub-Store_hash}/";
  country-lite_mmdb = fetchurl {
    url = "${meta-rules-dat_url}/country-lite.mmdb";
    hash = "sha256-Yss3PWXLbJNll+36yvGwYMgXe6Wf1nLdnl+6KKyeqi0=";
  };
  geosite_dat = fetchurl {
    url = "${meta-rules-dat_url}/geosite.dat";
    hash = "sha256-ctWwYGkAtwrHd4UC0/kSa/RNVRc5/RVsliu/Vyz6XTg=";
  };
  geoip_dat = fetchurl {
    url = "${meta-rules-dat_url}/geoip-lite.dat";
    hash = "sha256-q9Nvn+A+nGZIbcQthLvyP8VmhoCocGE+STWuiEl8p0k=";
  };
  ASN_mmdb = fetchurl {
    url = "${meta-rules-dat_url}/GeoLite2-ASN.mmdb";
    hash = "sha256-0G0Wg1/BID2of78SHMEi6s3cuVToOVKERUvuWfs6rcY=";
  };
  sub-store-bundle_js = fetchurl {
    url = "${Sub-Store_url}/sub-store.bundle.js";
    hash = "sha256-tENP31qFnDDeFUxSv5Pch+mtDZAJQroyiq8HjxcT3XU=";
  };
  dist_zip = fetchzip {
    url = "https://github.com/sub-store-org/Sub-Store-Front-End/releases/download/2.14.264/dist.zip";
    hash = "sha256-gGKzGpRMecU+TRVTWDEsfndSi2aCqP6HWJ0hfPRjq/8=";
  };
  NotoColorEmoji_ttf = fetchurl {
    url = "https://raw.githubusercontent.com/googlefonts/noto-emoji/f06dfe7cfb981a35a3edb98c9cc85c10151f7c79/fonts/NotoColorEmoji.ttf";
    hash = "sha256-wvGfakBLqn2npxCwGMKJLXtROGmD3coUaBH3auoLaGE=";
  };
in
stdenv.mkDerivation (finalAttrs: rec {
  pname = "mihomo-party";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "mihomo-party-org";
    repo = "mihomo-party";
    rev = "e35be65f544fada535053987866191d1f8f72e9e";
    hash = "sha256-J6Rn4AYXSSwQokSFf0zSBslBhufg9w0urIBhDeQQWsE=";
  };

  postPatch =
    ''
      cp ${./package.json} package.json
      cp ${./pnpm-lock.yaml} pnpm-lock.yaml
    ''
    + ''
      mkdir -p extra/sidecar extra/files src/renderer/src/assets extra/files/sub-store-frontend
      cp ${mihomo}/bin/mihomo extra/sidecar/mihomo-alpha
      chmod 755 extra/sidecar/mihomo-alpha
      cp ${mihomo}/bin/mihomo extra/sidecar/mihomo
      chmod 755 extra/sidecar/mihomo
      cp ${country-lite_mmdb} extra/files/country.mmdb
      cp ${geosite_dat} extra/files/geosite.dat
      cp ${geoip_dat} extra/files/geoip.dat
      cp ${ASN_mmdb} extra/files/ASN.mmdb
      cp ${sub-store-bundle_js} extra/files/sub-store.bundle.js
      cp -r ${dist_zip}/* extra/files/sub-store-frontend/
      cp ${NotoColorEmoji_ttf} src/renderer/src/assets/NotoColorEmoji.ttf
    '';

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Et1fCJxb7jpVuJYfps0dEPZI287ElIE/zZDyca5DXCo=";
  };

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    npm_config_arch = "x64";
    npm_config_target_arch = "x64";
  };

  makeCacheWritable = true;

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    nss
    nspr
    flac
    pulseaudio
    libGL
    mesa.drivers
    libxslt
    glib
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
    alsa-lib
    stdenv.cc.cc.lib
    libva
    libvdpau
    libdrm
  ];

  runtimeDependencies = map lib.getLib [ systemd ];

  buildPhase = ''
    runHook preBuild

    npm exec electron-vite build
    npm exec electron-builder -- \
        --publish never \
        --x64 \
        --linux dir \
        --config electron-builder.yml \
        -c.electronDist=${electron.dist} \
        -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/${pname}/
    cp -a dist/linux-unpacked/* $out/${pname}/
    chmod +x $out/mihomo-party/mihomo-party
    chmod +x $out/mihomo-party/resources/sidecar/mihomo
    chmod +x $out/mihomo-party/resources/sidecar/mihomo-alpha
    chmod 755 $out/mihomo-party
    chmod u+w $out/mihomo-party/mihomo-party
    patchelf --set-rpath ${libGL}/lib:$out/mihomo-party $out/mihomo-party/mihomo-party

    runHook postInstall
  '';

  preFixup = ''
    mkdir $out/bin
    wrapProgram $out/mihomo-party/mihomo-party \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libGL
          mesa.drivers
          glib
        ]
      }"
  '';

  meta = with lib; {
    description = "Another Mihomo GUI";
    homepage = "https://github.com/mihomo-party-org/mihomo-party";
    platforms = [ "x86_64-linux" ];
    mainProgram = "mihomo-party";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ aucub ];
  };
})
