# 将可重用的 home-manager 模块添加到此目录中,在它们自己的文件中 (https://nixos.wiki/wiki/Module),这些应该是分享的内容，而不是个人配置

{
  # 在此列出您的模块文件
  # my-module = import ./my-module.nix;
  fcitx5 = import ./fcitx5/default.nix;
  hypr = import ./hypr/default.nix;
  swaylock = import ./swaylock/default.nix;
}
