# 将可重用的home-manager模块添加到该目录中，作为独立的文件存在 (https://nixos.wiki/wiki/Module)
# 这些应该是您希望与他人分享的内容，而不是您的个人配置
{ inputs, outputs, lib, config, pkgs, ... }: {
  # 列出您的模块文件在此处
  # my-module = import ./my-module.nix;
  imports = [
    ./alacritty/default.nix
    ./bat/default.nix
    ./btop/default.nix
    ./fcitx5/default.nix
    ./fish/default.nix
    ./helix/default.nix
    ./htop/default.nix
    ./neofetch/default.nix
    ./ranger/default.nix
    ./nnn/default.nix
    ./zsh/default.nix
    ./vscode/default.nix
    ./tealdeer/default.nix
    ./hypr/default.nix
    ./lazygit/default.nix
  ];
}
