# Nix Configuration

## 部署

安装 NixOS 并启用 nix-command 和 flake 后，按照以下步骤部署

```bash
# 根据主机名部署其中一项配置
sudo nixos-rebuild switch --flake .
```

## 从 Flatpak 安装应用程序

可以从 flathub 安装应用程序，其中有很多应用程序在 nixpkgs 中得不到支持

```bash
# 添加 flathub 存储库
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# 从 flathub 安装应用程序
flatpak install netease-cloud-music-gtk

# 从 flathub 搜索应用程序
flatpak search <keyword>
# 网站搜索: https://flathub.org/
```

## 在 NixOS 上运行未修改的二进制文件

```shell
# 激活 FHS 会进入一个像普通 Linux 的 shell
$ fhs
(fhs) $ ls /usr/bin
(fhs) $ ./bin/code
```

对于其他方法: [在 Nixos 上运行非 nixos 可执行文件的方法](https://unix.stackexchange.com/questions/522822/different-methods-to-run-a-non-nixos-executable-on-nixos).