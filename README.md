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
# Add the Flathub repository
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# install apps from flathub
flatpak install netease-cloud-music-gtk

# install 3d printer slicer - cura
flatpak install flathub com.ultimaker.cura

# or you can search apps from flathub
flatpak search <keyword>
# search on website is also supported: https://flathub.org/
```

## 在 NixOS 上运行未修改的二进制文件

> the `fhs` command is defined at [./modules/nixos/core-desktop.nix#L145](https://github.com/ryan4yin/nix-config/blob/v0.0.5/modules/nixos/core-desktop.nix#L145)

```shell
# Activating FHS drops me in a shell which looks like a "normal" Linux
$ fhs
(fhs) $ ls /usr/bin
(fhs) $ ./bin/code
```

for other methods, check out [Different methods to run a non-nixos executable on Nixos](https://unix.stackexchange.com/questions/522822/different-methods-to-run-a-non-nixos-executable-on-nixos).