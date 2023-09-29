# Nix Configuration 

![](./assets/Screenshot_Kde.jpg)

## 部署

### 安装

1. 格式化分区
2. 挂载
3. 生成一个基本的配置 
```bash
nixos-generate-config --root /mnt
```
4. 克隆仓库
```bash
export NIX_CONFIG="experimental-features = nix-command flakes" 

nix-shell -p git 

cd  /mnt/etc/nixos 

nix develop --extra-experimental-features nix-command --extra-experimental-features flakes
```
5. 拷贝 /mnt/etc/nixos 中的 `hardware-configuration.nix` 
6. 安装
```bash
nixos-install --no-root-passwd --flake .#legion

#或者指定源：
nixos-install --option substituters "https://mirrors.bfsu.edu.cn/nix-channels/store" --no-root-passwd --flake .#legion
```

### 重建

安装 NixOS 并启用 nix-command 和 flake 后，按照以下步骤部署

```bash
# 根据主机名部署其中一项配置
sudo nixos-rebuild switch --install-bootloader --flake .#legion
```