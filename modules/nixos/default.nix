{
  chromium = import ./chromium.nix;
  fcitx5 = import ./fcitx5.nix;
  gnome = import ./gnome.nix;
  nvidia-disable = import ./nvidia-disable.nix;
  nvidia = import ./nvidia.nix;
  containers = import ./containers.nix;
  dbus-1 = import ./dbus-1/default.nix;
}
