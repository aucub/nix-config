{
  lib,
  stdenv,
  fetchFromGitLab,
  blueprint-compiler,
  desktop-file-utils,
  gettext,
  gtk4,
  json-glib,
  libadwaita,
  libgee,
  libportal,
  libportal-gtk4,
  libsoup_3,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook,
}:
let
  version = "0.2.2";
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "subpop";
    repo = "damask";
    rev = "v${version}";
    hash = "sha256-X1snGqI6KJpXjFyPT//VEuHEI6nssIwiWbW0773NJTw=";
  };
in
stdenv.mkDerivation {
  inherit version src;
  pname = "damask";

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    gettext
    gtk4
    json-glib
    libadwaita
    libgee
    libportal
    libportal-gtk4
    libsoup_3
  ];

  meta = {
    description = "Automatically set wallpaper images from Internet sources";
    homepage = "https://gitlab.gnome.org/subpop/damask";
    maintainers = with lib.maintainers; [ samdroid-apps ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    mainProgram = "damask";
  };
}
