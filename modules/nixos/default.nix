# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  yazi = import ./yazi.nix;
  chromium = import ./chromium.nix;
  fcitx5 = import ./fcitx5.nix;
}
