{
  colord = import ./colord/default.nix;
  dotfiles = import ./dotfiles/default.nix;
  chromium = import ./chromium.nix;
  dconf = import ./dconf.nix;
  gui = import ./gui.nix;
  shell = import ./shell.nix;
  vscode = import ./vscode.nix;
  wofi = import ./wofi.nix;
}
