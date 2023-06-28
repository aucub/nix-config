# 将可重用的NixOS模块添加到此目录中，以独立的文件形式存在(https: //nixos.wiki/wiki/Module)
# 这些应该是您想与他人共享的内容，而不是个人配置

{
  # 列出您的模块文件在此处
  # my-module = import ./my-module.nix;
  environment = import ./environment/variables.nix;
  fonts = import ./fonts/default.nix;
  hardware = import ./hardware/default.nix;
  hyprland = import ./hyprland/default.nix;
}