{
  lib,
  fetchurl,
  stdenv,
  unzip,
}:
let
  version = "1.2.4";
  src = fetchurl {
    url = "https://github.com/bepass-org/warp-plus/releases/download/v${version}/warp-plus_linux-amd64.zip";
    sha256 = "Xnzedjktvdzryf3vXZtsRfNsIlgKiSCs0GcxrNeUHrs=";
  };
in
stdenv.mkDerivation {
  inherit version src;

  pname = "warp-plus";

  dontUnpack = true;

  dontBuild = true;

  nativeBuildInputs = [
    unzip
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    unzip ${src} -d $out/bin
    rm $out/bin/LICENSE
    rm $out/bin/README.md

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/bepass-org/warp-plus";
    description = "Warp+Psiphon, an anti censorship utility for iran";
    maintainers = with lib.maintainers; [ aucub ];
    license = with lib.licenses; [ mit ];
    platforms = with lib.platforms; linux ++ darwin;
    broken = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64);
    mainProgram = "warp-plus";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
