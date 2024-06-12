{
  stdenv,
  lib,
}:
stdenv.mkDerivation {
  pname = "upower-conf";
  version = "1.0.0";

  dontUnpack = true;
  src = ./org.freedesktop.UPower.conf;

  installPhase = ''
    mkdir -p $out/share/dbus-1/system.d
    cp $src $out/share/dbus-1/system.d/org.freedesktop.UPower.conf
  '';

  meta = with lib; {
    description = "UPower configuration";
    license = licenses.free;
    maintainers = with maintainers; [uc];
  };
}
