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
    hash = "sha256-Xnzedjktvdzryf3vXZtsRfNsIlgKiSCs0GcxrNeUHrs=";
  };
in
stdenv.mkDerivation {
  inherit version src;
  pname = "warp-plus";

  nativeBuildInputs = [
    unzip
  ];

  unpackPhase = ''
    unzip ${src} -d .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./warp-plus $out/bin/warp-plus

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/bepass-org/warp-plus";
    description = "Warp+Psiphon, an anti censorship utility for iran";
    maintainers = with lib.maintainers; [ aucub ];
    license = with lib.licenses; [ mit ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "warp-plus";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
