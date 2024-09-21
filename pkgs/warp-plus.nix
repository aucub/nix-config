{
  lib,
  fetchurl,
  stdenv,
  unzip,
}:
let
  pname = "warp-plus";
  version = "1.2.4";
  src = fetchurl {
    url = "https://github.com/bepass-org/warp-plus/releases/download/v${version}/warp-plus_linux-amd64.zip";
    sha256 = "Xnzedjktvdzryf3vXZtsRfNsIlgKiSCs0GcxrNeUHrs=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  dontConfigure = true;
  dontBuild = true;

  buildInputs = [
    unzip
  ];

  unpackPhase = ''
    runHook preUnpack

    mkdir -p $out/bin
    unzip ${src} -d $out/bin

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    rm $out/bin/LICENSE
    rm $out/bin/README.md

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
