{
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  vala,
  blueprint-compiler,
  json-glib,
  libadwaita,
  libgee,
  libportal-gtk4,
  libsoup3,
  appstream-glib,
}:
stdenv.mkDerivation {
  pname = "damask-wallpaper";
  version = "0.2.2";

  src = fetchFromGitLab {
    owner = "subpop";
    repo = "damask";
    rev = "v${version}";
    sha256 = "1e1939af48c89665a7d28f146e0105a4bc8262bc0a152c1f697d4c87609ea255";
  };

  nativeBuildInputs = [meson ninja vala blueprint-compiler];
  buildInputs = [json-glib libadwaita libgee libportal-gtk4 libsoup3];

  checkInputs = [appstream-glib];

  buildPhase = ''
    meson build
    ninja -C build
  '';

  checkPhase = ''
    meson test -C build --print-errorlogs
  '';

  installPhase = ''
    meson install -C build --destdir $out
  '';
}
