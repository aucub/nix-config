# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  fcitx5 = import ./fcitx5/default.nix;
  firefox = import ./firefox/default.nix;
  chromium = import ./chromium/default.nix;
  dconf = import ./dconf.nix;
}
