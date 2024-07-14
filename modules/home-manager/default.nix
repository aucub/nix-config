{
  firefox = import ./firefox.nix;
  dconf = import ./dconf.nix;
  vscode = import ./vscode.nix;
  chromium = import ./chromium.nix;
  wofi = import ./wofi.nix;
  fish = import ./fish.nix;
  dotfiles = import ./dotfiles/default.nix;
  colord = import ./colord/default.nix;
  shared = import ./shared.nix;
}
