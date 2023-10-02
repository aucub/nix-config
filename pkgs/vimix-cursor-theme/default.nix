{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:
stdenvNoCC.mkDerivation rec {
  pname = "vimix-cursor-theme";
  version = "2020-02-24";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Vimix-cursors";
    rev = "9bc292f40904e0a33780eda5c5d92eb9a1154e9c";
    sha256 = "sha256-zW7nJjmB3e+tjEwgiCrdEe5yzJuGBNdefDdyWvgYIUU=";
  };

  installPhase = ''
    install -dm 0755 $out/share/icons
    cp -pr dist/ $out/share/icons/Vimix-cursors
    cp -pr dist-white/ $out/share/icons/Vimix-white-cursors
  '';

  meta = with lib; {
    description = "This is an x-cursor theme inspired by Materia design and based on capitaine-cursors";
    homepage = "https://github.com/vinceliuice/Vimix-cursors";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [
      aucub
    ];
  };
}
