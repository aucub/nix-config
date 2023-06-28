# 将可重用的home-manager模块添加到该目录中，作为独立的文件存在 (https://nixos.wiki/wiki/Module)
# 这些应该是您希望与他人分享的内容，而不是您的个人配置

{
  # 列出您的模块文件在此处
  # my-module = import ./my-module.nix;
  alacritty = import ./alacritty/default.nix;
  btop = import ./btop/default.nix;
  fcitx5 = import ./fcitx5/default.nix;
  fish = import ./fish/default.nix;
  helix = import ./helix/default.nix;
  htop = import ./htop/default.nix;
  neofetch = import ./neofetch/default.nix;
  ranger = import ./ranger/default.nix;

}
