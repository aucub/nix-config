{
  chromium = import ./chromium.nix;
  fcitx5 = import ./fcitx5.nix;
  gnome = import ./gnome.nix;
  nvidia-disable = import ./nvidia-disable.nix;
  nvidia = import ./nvidia.nix;
  containers = import ./containers.nix;
  steam = import ./steam.nix;
  shared = import ./shared.nix;
}
